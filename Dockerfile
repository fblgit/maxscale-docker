FROM centos:7
MAINTAINER Andrea Sosso <andrea.sosso@dnshosting.it>

RUN rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB \
    && yum -y install https://downloads.mariadb.com/enterprise/yzsw-dthq/generate/10.0/mariadb-enterprise-repository.rpm \
    && yum -y update \
    && yum -y install epel-release \
    && yum -y install \
        libaio \
        libedit \
        librabbitmq \
    && rpm -ivh http://maxscale-jenkins.mariadb.com/ci-repository/1.3.0-beta-release/mariadb-maxscale/centos/7/x86_64/maxscale-beta-1.3.0-1.centos7.x86_64.rpm \
    && yum clean all \
    && rm -rf /tmp/*

# Move configuration file in directory for exports
RUN mkdir -p /etc/maxscale.d \
    && cp /etc/maxscale.cnf.template /etc/maxscale.d/maxscale.cnf \
    && ln -sf /etc/maxscale.d/maxscale.cnf /etc/maxscale.cnf

# VOLUME for custom configuration
VOLUME ["/etc/maxscale.d"]

# EXPOSE the MaxScale default ports

## RW Split Listener
EXPOSE 4006

## Read Connection Listener
EXPOSE 4008

## Debug Listener
EXPOSE 4442

## CLI Listener
EXPOSE 6603

# Running MaxScale
ENTRYPOINT ["/usr/bin/maxscale", "-d"]
