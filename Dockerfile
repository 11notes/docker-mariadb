FROM mariadb:10.4
RUN usermod -u 1000 mysql \
	&& groupmod -g 1000 mysql \
	&& chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
USER mysql:mysql