# provision php virtual machine
source entrypoint.sh
curl -sL https://deb.nodesource.com/setup_10.x | bash
apt-get update
apt-get -y install libpcre3-dev zlib1g-dev libbz2-dev libpng-dev libjpeg-dev nodejs git zip unzip curl rsync mysql-client nano
docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr
docker-php-ext-install zip bz2 gd mysqli pdo pdo_mysql

# Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "copy('https://composer.github.io/installer.sig', 'composer-setup.sig');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === trim(file_get_contents('composer-setup.sig'))) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"
php -r "unlink('composer-setup.sig');"


# WP CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
# This package compiles blade templates without a frontend trigger
php -d memory_limit=1024M /usr/local/bin/wp --allow-root package install git@github.com:alwaysblank/blade-generate.git

# SSH
which ssh-agent || ( apt-get update -y && apt-get install openssh-client -y )
eval $(ssh-agent -s)
[[ -f /.dockerenv ]] && echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
mkdir -p ~/.ssh
ssh-add <(echo "$SSH_PRIVATE_KEY")