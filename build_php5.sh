#!/bin/sh


# usage - ./build_php5.sh php-5.4.44
# where php-5.4.44 is a PHP source directory

# Ubuntu users only, a quirk to locate libpcre
if [ ! -f "/usr/lib/libpcre.a" ]; then
	if [ -f "/usr/lib/i386-linux-gnu/libpcre.a" ]; then
		sudo ln -s /usr/lib/i386-linux-gnu/libpcre.a /usr/lib/libpcre.a
	elif [ -f "/usr/lib/x86_64-linux-gnu/libpcre.a" ]; then
		sudo ln -s /usr/lib/x86_64-linux-gnu/libpcre.a /usr/lib/libpcre.a
	fi
fi

# define full path to php sources"
PHP5_SRC="$HOME/php-5.4.44"

if [ ! -d "$PHP5_SRC" ]; then
	echo "PHP source is not a valid directory."
	exit 1
fi

# define parent path where php installation goes to
PHP5_BASE_PATH="/opt/php54"

# Here following paths are required for installation binaries && general settings
PREFIX="$PHP5_BASE_PATH"
BIN_DIR="$PREFIX/bin"
SBIN_DIR="$PREFIX/sbin"
LIBEXEC_DIR="$PREFIX/libexec"
SYSCONF_DIR="$PREFIX/etc"
CONFD_DIR="$PREFIX/conf.d"
SHAREDSTATE_DIR="$PREFIX/com"
LOCALSTATE_DIR="$PREFIX/var"
LIB_DIR="$PREFIX/lib"
INCLUDE_DIR="$PREFIX/include"
MAN_DIR="$PREFIX/share/man"
EXTENSION_DIR="$PREFIX/share/modules" # all shared modules will be installed in /opt/php54/share/modules  phpize binary will configure it accordingly
export EXTENSION_DIR
PEAR_INSTALLDIR="$PREFIX/share/pear"  # pear package directory
export PEAR_INSTALLDIR

# Here follows a main configuration script
PHP_CONF="--config-cache \
	--prefix=$PREFIX \
	--bindir=$BIN_DIR \
	--sbindir=$SBIN_DIR \
	--libexecdir=$LIBEXEC_DIR \
	--sysconfdir=$SYSCONF_DIR \
	--sharedstatedir=$SHAREDSTATE_DIR \
	--localstatedir=$LOCALSTATE_DIR \
	--libdir=$LIB_DIR \
	--includedir=$INCLUDE_DIR \
	--with-layout=GNU \
	--with-config-file-path=$SYSCONF_DIR \
	--with-config-file-scan-dir=$CONFD_DIR \
	--disable-rpath \
	--mandir=$MAN_DIR \
	--enable-sigchild
"

# enter source directory
cd $PHP5_SRC

# Additionally you can add these, if they are needed
#	--enable-ftp
# 	--enable-exif
#	--enable-calendar
#	--with-snmp=/usr
#	--with-tidy=/usr
#	--with-xmlrpc
#	--with-xsl=/usr
# and any other, run "./configure --help" inside php sources

# define extension configuration
EXT_CONF="--enable-bcmath \
	--enable-calendar \
	--enable-ftp \
	--enable-mbstring \
	--enable-mbregex \
	--enable-posix \
	--enable-soap \
	--enable-dba \
	--enable-wddx \
	--enable-sockets \
	--enable-sysvmsg \
	--enable-sysvshm \
	--enable-shmop \
	--enable-zip \
	--enable-inline-optimization \
	--enable-intl \
	--enable-exif \
	--with-icu-dir=/usr \
	--with-curl=/usr/bin \
	--with-gd \
	--with-jpeg-dir=/usr \
	--with-png-dir=shared,/usr \
	--with-xpm-dir=/usr \
	--enable-gd-native-ttf \
	--enable-gd-jis-conv \
	--with-freetype-dir=/usr \
	--with-bz2=/usr \
	--with-gettext \
	--with-gmp \
	--with-iconv-dir=/usr \
	--with-mcrypt=/usr \
	--with-mhash \
	--with-zlib-dir=/usr \
	--with-regex=php \
	--with-pcre-regex=/usr \
	--with-openssl \
	--with-openssl-dir=/usr/bin \
	--with-mysql-sock=/var/run/mysqld/mysqld.sock \
	--with-mysqli=mysqlnd \
	--with-sqlite3=/usr \
	--with-pdo-mysql=mysqlnd \
	--with-pdo-sqlite=/usr \
	--with-pdo-pgsql \
	--with-pgsql \
	--with-xmlrpc \
	--with-ldap=/usr --with-libdir=/lib/x86_64-linux-gnu
"

# CLI, php-fpm and apache2 module
./configure $PHP_CONF \
	--disable-cgi \
	--with-readline \
	--enable-pcntl \
	--enable-cli \
	--with-pear \
	$EXT_CONF

# CGI and FastCGI
#./configure $PHP_CONF --disable-cli --enable-cgi $EXT_CONF

# build sources
make
