# =============================================================================
# viklund/centos-devbox
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

RUN yum -y install \
        openssh \
        openssh-server \
        openssh-clients \
        python-pip \
    && yum -y reinstall cracklib-dicts \
    && yum -y update bash \
    && rm -rf /var/cache/yum/* \
    && yum clean all

# -----------------------------------------------------------------------------
# Install supervisord (required to run more than a single process in a container)
# Note: EPEL package lacks /usr/bin/pidproxy
# We require supervisor-stdout to allow output of services started by
# supervisord to be easily inspected with "docker logs".
#
# And virtualenv
# -----------------------------------------------------------------------------
RUN pip install --upgrade 'pip >= 1.4, < 1.5' \
    && pip install --upgrade supervisor supervisor-stdout \
    && mkdir -p /var/log/supervisor/ \
    && pip install virtualenv

# -----------------------------------------------------------------------------
# Europe/Stockholm Timezone & Networking
# -----------------------------------------------------------------------------
RUN ln -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime \
    && echo "NETWORKING=yes" > /etc/sysconfig/network

# -----------------------------------------------------------------------------
# Make the custom configuration directory
# -----------------------------------------------------------------------------
RUN mkdir -p /etc/services-config/ssh

# -----------------------------------------------------------------------------
# Copy files into place
# -----------------------------------------------------------------------------
ADD etc/ssh-bootstrap /etc/
ADD etc/services-config/ssh/authorized_keys /etc/services-config/ssh/
ADD etc/services-config/ssh/sshd_config /etc/services-config/ssh/
ADD etc/services-config/ssh/ssh-bootstrap.conf /etc/services-config/ssh/
ADD etc/services-config/supervisor/supervisord.conf /etc/

RUN chmod 600 /etc/services-config/ssh/sshd_config \
    && chmod +x /etc/ssh-bootstrap \
    && ln -sf /etc/services-config/ssh/sshd_config /etc/ssh/sshd_config \
    && ln -sf /etc/services-config/ssh/ssh-bootstrap.conf /etc/ssh-bootstrap.conf \
    && mkdir -p /etc/supervisord

# -----------------------------------------------------------------------------
# Expose
# -----------------------------------------------------------------------------

EXPOSE 22

CMD ["/usr/bin/supervisord", "--configuration=/etc/supervisord.conf"]
