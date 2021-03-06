function fetch_php5_packages() {
  if [ -n "$BUILDPACK_CLEAN_CACHE" ] ; then
    rm -rf $PHP_CACHE_DIR
  fi

  if [ -z "$GET_PACKAGE_LIST" ] ; then
    get_apt_updates
    GET_PACKAGE_LIST=1
  fi

  if [ ! -d $PHP_CACHE_DIR ] ; then
    mkdir -p $PHP_CACHE_DIR
    apt-get --print-uris --yes install libapache2-mod-php5 \
                                       php5-gd php5-imagick \
                                       php5-curl php5-imap php5-mcrypt \
                                       php5-redis php5-memcache php5-memcached \
                                       php5-mysql php5-pgsql \
                                       php5-apc php5-cli php-pear | grep ^\' | cut -d\' -f2 > $PHP_CACHE_DIR/downloads.list

    wget --input-file $PHP_CACHE_DIR/downloads.list -P $PHP_CACHE_DIR > /dev/null 2>&1
  else
    echo '(from cache)' | indent
  fi

  dpkg -i $PHP_CACHE_DIR/*.deb > /dev/null 2>&1

  version=$(dpkg -l | grep php5 | head -n 1 | awk '{print $3}')
  echo "PHP installed : $version" | indent
}


function install_php5_configuration() {
  cp "$BP_DIR/conf/php/php.ini" /etc/php5/apache2/php.ini
}
