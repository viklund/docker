# =============================================================================
# viklund/devbox-agda
# =============================================================================
FROM viklund/devbox-slurm:latest

MAINTAINER Johan Viklund <johan.viklund@bils.se>

# -----------------------------------------------------------------------------
# Copy requirements.txt and create virtual env for the django-app
# -----------------------------------------------------------------------------

RUN yum -y install python-virtualenv cracklib-devel mysql-devel python-devel \
                openldap-devel openssl-devel libgsasl-devel

COPY requirements.txt /srv/
COPY supervisor_django.conf /etc/supervisord/
COPY start-app.sh /etc/
RUN virtualenv /srv/agda-virtual-env \
    && source /srv/agda-virtual-env/bin/activate \
    && pip install -r /srv/requirements.txt \
    && chmod +x /etc/start-app.sh
