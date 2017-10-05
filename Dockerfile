FROM abdalla/python2-mysql

COPY ./deps/requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

RUN apt-get update

RUN apt-get install unixodbc-dev -y
RUN apt-get install libssl-dev -y

COPY /deps/unixODBC-2.3.4/ ./
RUN ./configure --disable-gui --disable-drivers --enable-iconv --with-iconv-char-enc=UTF8 --with-iconv-ucode-enc=UTF16LE
RUN make
RUN make install
RUN cd /usr/local/lib/
RUN ldconfig

COPY /deps/msodbcsql-13.0.0.0/ ./
RUN ./install.sh install --force --accept-license

COPY /deps/ ./
RUN sh installodbc.sh

RUN pip install pyodbc
RUN pip install mysql-connector-python-rf

# Those dependencies should be into requirements.txt file
RUN pip install passlib
RUN pip install boto3

ADD . /app
WORKDIR /app

RUN odbcinst -i -d -f ./deps/msodbcsql-13.0.0.0/tds.driver.template2

EXPOSE 80

CMD ["gunicorn","-b","0.0.0.0:80","-w","1","-k","gevent","--log-file","-","--log-level","debug","--access-logfile","-","server:app"]
