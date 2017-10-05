apt-get update
rm -rf /tmp/msodbcubuntu
mkdir /tmp/msodbcubuntu
wget ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.1.tar.gz -P /tmp/msodbcubuntu/
cd /tmp/msodbcubuntu
tar -xzf /tmp/msodbcubuntu/unixODBC-2.3.1.tar.gz
cd /tmp/msodbcubuntu/unixODBC-2.3.1/
apt-get install g++-5
echo "Configuring the unixODBC 2.3.1 Driver Manager"
./configure --disable-gui --disable-drivers --enable-iconv --with-iconv-char-enc=UTF8 --with-iconv-ucode-enc=UTF16LE 1> odbc_con.log 2> moake_err.log
echo "Building and Installing the unixODBC 2.3.1 Driver Manager"
make 1> make_std.log 2> moake_err.log
make install 1> makeinstall_std.log 2> makeinstall_err.log

echo "Downloading the Microsoft ODBC Driver 13 for SQL Server- Ubuntu"
wget https://download.microsoft.com/download/2/E/5/2E58F097-805C-4AB8-9FC6-71288AB4409D/msodbcsql-13.0.0.0.tar.gz -P /tmp/msodbcubuntu
cd /tmp/msodbcubuntu/
tar xvfz /tmp/msodbcubuntu/msodbcsql-13.0.0.0.tar.gz
cd /tmp/msodbcubuntu/msodbcsql-13.0.0.0/
ldd /tmp/msodbcubuntu/msodbcsql-13.0.0.0/lib64/libmsodbcsql-13.0.so.0.0
echo "Installing Dependencies"
apt-get install libssl1.0.0 -y
apt-get install libgss3 -y
ldconfig
echo "Installing the Microsoft ODBC Driver 13 for SQL Server- Ubuntu"
bash ./install.sh install --force --accept-license
echo "Cleaning up"
rm -rf /tmp/msodbcubuntu
