# :: Header
FROM mariadb:10.4.8

# :: Run
# :: docker -u 1000:1000 (no root initiative)
RUN APP_UID="$(id -u mysql)" \
    && APP_GID="$(id -g mysql)" \
    && find / -not -path "/proc/*" -user $APP_UID -exec chown -h -R 1000:1000 {} \;\
    && find / -not -path "/proc/*" -group $APP_GID -exec chown -h -R 1000:1000 {} \;
RUN usermod -u 1000 mysql \
	&& groupmod -g 1000 mysql \
	&& chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# :: Start
USER mysql