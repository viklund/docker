# =============================================================================
# viklund/devbox-agda
# =============================================================================
FROM viklund/devbox-slurm:latest

MAINTAINER Johan Viklund <johan.viklund@bils.se>


RUN yum -y install python-virtualenv cracklib-devel mysql-devel python-devel \
                openldap-devel openssl-devel libgsasl-devel \
                wget

# -----------------------------------------------------------------------------
# Install cmod
# -----------------------------------------------------------------------------

RUN wget ftp://ftp.lysator.liu.se/pub/unix/cmod/cmod-1.1.tar.gz \
    && tar xzvf cmod-1.1.tar.gz \
    && cd cmod-1.1 \
    && ./configure --prefix=/usr --sysconfdir=/etc \
    && make \
    && make install

# -----------------------------------------------------------------------------
# Copy requirements.txt and create virtual env for the django-app
# -----------------------------------------------------------------------------

COPY requirements.txt /srv/
COPY supervisor_django.conf /etc/supervisord/
COPY start-app.sh /etc/

RUN virtualenv /srv/agda-virtual-env \
    && source /srv/agda-virtual-env/bin/activate \
    && pip install -r /srv/requirements.txt \
    && chmod +x /etc/start-app.sh
