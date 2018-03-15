FROM ubuntu:16.04
MAINTAINER Eduard Istvan Sas <eduard.istvan.sas@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

COPY docker-entrypoint.sh /usr/local/bin/
COPY respond.txt /tmp

RUN rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Bucharest /etc/localtime \
 && echo "Europe/Bucharest" > /etc/timezone \
 && apt-get update \
 && apt-get -y dist-upgrade \
 && apt-get update \
 && apt-get install -y php apache2 libapache2-mod-php git \
 && rm -rf /var/www/html/* \
 && a2enmod rewrite \
 && cd /tmp \
 && git clone https://github.com/fogproject/fogproject.git fog_1.5.0/ \
 && cd fog_1.5.0/bin \
 && export LANG=C.UTF-8 \
 && cat /tmp/respond.txt | ./installfog.sh \
 

# Apache musthave env vars
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80
EXPOSE 443

CMD ["/usr/local/bin/docker-entrypoint.sh"]

