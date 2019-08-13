# :: Header
FROM mariadb:10.4.7

# :: Run
# :: docker -u 1000:1000 (no root initiative)
RUN usermod -u 1000 mysql \
	&& groupmod -g 1000 mysql \
	&& chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# :: Start
USER mysql