# ╔═════════════════════════════════════════════════════╗
# ║                       SETUP                         ║
# ╚═════════════════════════════════════════════════════╝
  # GLOBAL
  ARG APP_UID=1000 \
      APP_GID=1000

  # :: FOREIGN IMAGES
  FROM 11notes/util AS util
  FROM 11notes/distroless:tini-pm AS tini-pm


# ╔═════════════════════════════════════════════════════╗
# ║                       IMAGE                         ║
# ╚═════════════════════════════════════════════════════╝
  # :: HEADER
  FROM 11notes/alpine:stable

  # :: default arguments
    ARG TARGETPLATFORM \
        TARGETOS \
        TARGETARCH \
        TARGETVARIANT \
        APP_IMAGE \
        APP_NAME \
        APP_VERSION \
        APP_ROOT \
        APP_UID \
        APP_GID \
        APP_NO_CACHE

  # :: default environment
    ENV APP_IMAGE=${APP_IMAGE} \
        APP_NAME=${APP_NAME} \
        APP_VERSION=${APP_VERSION} \
        APP_ROOT=${APP_ROOT}

  # :: app specific variables
    ENV MARIADB_SOCKET=/run/mariadb/mariadbd.sock \
        MARIADB_CONF=${APP_ROOT}/etc/default.cnf

  # :: multi-stage
    COPY --from=util /usr/local/bin /usr/local/bin
    COPY --from=tini-pm / /

# :: RUN
  USER root
  RUN eleven printenv;

  # :: prepare image
    RUN set -ex; \
      eleven mkdir ${APP_ROOT}/{etc,var,backup}; \
      mkdir -p ${APP_ROOT}/var/tmp; \
      mkdir -p /run/cmd; \
      rm -rf /var/tmp; \
      ln -sf ${APP_ROOT}/var/tmp /var/tmp;

  # :: install application
    RUN set -ex; \
      apk --no-cache --update add \
        mariadb=~${APP_VERSION} \
        mariadb-client=~${APP_VERSION} \
        mariadb-backup;

  # :: set uid/gid to 1000:1000 for existing user
    RUN set -ex; \
      eleven changeUserToDocker mysql;

  # :: copy filesystem changes and set correct permissions
    COPY ./rootfs /
    RUN set -ex; \
      chmod +x -R /usr/local/bin; \
      chown -R ${APP_UID}:${APP_GID} \
        ${APP_ROOT};

# :: PERSISTENT DATA
  VOLUME ["${APP_ROOT}/etc", "${APP_ROOT}/var", "${APP_ROOT}/backup"]

# :: HEALTH
  HEALTHCHECK --interval=5s --timeout=2s --start-interval=30s \
    CMD ["/usr/local/bin/healthcheck.sh"]

# :: EXECUTE
  USER ${APP_UID}:${APP_GID}
  ENTRYPOINT ["/usr/local/bin/tini-pm", "--socket"]