FROM ubuntu:16.04
MAINTAINER Eduard Istvan Sas <eduard.istvan.sas@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

ADD docker-entrypoint.sh /usr/local/bin/
ADD respond.txt /tmp

RUN rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Bucharest /etc/localtime \
 && echo "Europe/Bucharest" > /etc/timezone \
 && apt-get update \
 && apt-get -y dist-upgrade \
 && apt-get update \
 && apt-get install -y php apache2 libapache2-mod-php mysql-server git \
 && apt-get clean \
 && ln -s /etc/apparmor.d/usr.sbin.mysqld /etc/apparmor.d/disable/usr.sbin.mysqld \
 && rm -rf /var/www/html/* \
 && a2enmod rewrite \
 && cd /tmp \
 && git clone https://github.com/fogproject/fogproject.git fog_1.5.0/ \
 && cd fog_1.5.0/bin \
 && export LANG=C.UTF-8 \
 && cat /tmp/respond.txt | bash ./installfog.sh -X 


# Apache musthave env vars
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 21/tcp 80/tcp 111/tcp 2049/tcp 4045/tcp 8099/tcp 9098/tcp 34463/tcp 69/udp 111/udp 212/udp 2049/udp 4045/udp 34463/udp

CMD ["/usr/local/bin/docker-entrypoint.sh"]

