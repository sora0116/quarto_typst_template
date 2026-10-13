FROM ghcr.io/quarto-dev/quarto:1.10.19@sha256:966609c3b165de4a3f259527549c6f750cbe5298a1d35aac39313a37954578ff

USER root

# Install R and the packages required for Quarto's knitr engine.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        libuv1-dev \
        r-base \
        r-base-dev \
        r-cran-knitr \
        r-cran-rmarkdown \
    && rm -rf /var/lib/apt/lists/* \
    && R -q -e "install.packages('renv', repos = 'https://cloud.r-project.org')"

ENV RENV_CONFIG_AUTO_SNAPSHOT=FALSE \
    RENV_PATHS_CACHE=/opt/renv/cache

RUN mkdir -p /opt/renv/cache \
    && chmod 777 /opt/renv/cache

WORKDIR /work
EXPOSE 4200
CMD ["quarto", "preview", "--host", "0.0.0.0", "--port", "4200"]
