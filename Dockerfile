# =============================================================================
# jdeathe/centos-ssh
#
# CentOS-6 6.5 x86_64 / EPEL Repo. / OpenSSH / Supervisor.
# 
# =============================================================================
FROM centos:centos6

MAINTAINER Johan Viklund <johan.viklund@bils.se>

# -----------------------------------------------------------------------------
# Import the Centos-6 RPM GPG key to prevent warnings and Add EPEL Repository
# -----------------------------------------------------------------------------
RUN rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-6 \
    && rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6 \
    && rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# -----------------------------------------------------------------------------
# Base Install
# -----------------------------------------------------------------------------
RUN yum -y reinstall cracklib-dicts

RUN yum -y install \
    git \
    vim \
    sudo \
    openssh \
    openssh-server \
    openssh-clients \
    man \
    python-pip \
    && yum -y update bash \
    && rm -rf /var/cache/yum/* \
    && yum clean all

RUN yum -y groupinstall "Development Tools"

# -----------------------------------------------------------------------------
# Install supervisord (required to run more than a single process in a container)
# Note: EPEL package lacks /usr/bin/pidproxy
# We require supervisor-stdout to allow output of services started by 
# supervisord to be easily inspected with "docker logs".
# -----------------------------------------------------------------------------
RUN pip install --upgrade 'pip >= 1.4, < 1.5' \
    && pip install --upgrade supervisor supervisor-stdout \
    && mkdir -p /var/log/supervisor/

RUN pip install virtualenv

# -----------------------------------------------------------------------------
# Europe/Stockholm Timezone & Networking
# -----------------------------------------------------------------------------
RUN ln -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime \
    && echo "NETWORKING=yes" > /etc/sysconfig/network

# -----------------------------------------------------------------------------
# Configure SSH for non-root public key authentication
# -----------------------------------------------------------------------------
RUN sed -i \
    -e 's/^UsePAM yes/#UsePAM yes/g' \
    -e 's/^#UsePAM no/UsePAM no/g' \
    -e 's/^#PermitRootLogin yes/PermitRootLogin no/g' \
    -e 's/^#UseDNS yes/UseDNS no/g' \
    /etc/ssh/sshd_config

# -----------------------------------------------------------------------------
# Enable the wheel sudoers group
# -----------------------------------------------------------------------------
RUN sed -i 's/^# %wheel\tALL=(ALL)\tNOPASSWD: ALL/%wheel\tALL=(ALL)\tNOPASSWD: ALL/' /etc/sudoers

# -----------------------------------------------------------------------------
# Make the custom configuration directory
# -----------------------------------------------------------------------------
RUN mkdir -p /etc/services-config/{supervisor,ssh}

# -----------------------------------------------------------------------------
# Copy files into place
# -----------------------------------------------------------------------------
ADD etc/ssh-bootstrap /etc/
ADD etc/services-config/ssh/authorized_keys /etc/services-config/ssh/
ADD etc/services-config/ssh/sshd_config /etc/services-config/ssh/
ADD etc/services-config/ssh/ssh-bootstrap.conf /etc/services-config/ssh/
ADD etc/services-config/supervisor/supervisord.conf /etc/services-config/supervisor/

RUN chmod 600 /etc/services-config/ssh/sshd_config \
    && chmod +x /etc/ssh-bootstrap \
    && ln -sf /etc/services-config/supervisor/supervisord.conf /etc/supervisord.conf \
    && ln -sf /etc/services-config/ssh/sshd_config /etc/ssh/sshd_config \
    && ln -sf /etc/services-config/ssh/ssh-bootstrap.conf /etc/ssh-bootstrap.conf

# -----------------------------------------------------------------------------
# Expose
# -----------------------------------------------------------------------------

EXPOSE 22
EXPOSE 80
EXPOSE 443
EXPOSE 8000
EXPOSE 8001

CMD ["/usr/bin/supervisord", "--configuration=/etc/supervisord.conf"]
