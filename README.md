# Software Bill of Materials

# bom-scanner_and_DT
Runs a centos image and the Dependency Track image. Auto generates 3 syft BOM files for 3(JAVA,.Net,Python) example projects.

# run containers
docker compose up

local/c8-systemd in Dockerfile is a base image for centos with systemctl enabled:
# 

#### FROM centos:latest
#### ENV container docker
#### RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
#### systemd-tmpfiles-setup.service ] || rm -f $i; done); \
#### rm -f /lib/systemd/system/multi-user.target.wants/*;\
#### rm -f /etc/systemd/system/*.wants/*;\
#### rm -f /lib/systemd/system/local-fs.target.wants/*; \
#### rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
#### rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
#### rm -f /lib/systemd/system/basic.target.wants/*;\
#### rm -f /lib/systemd/system/anaconda.target.wants/*;
#### VOLUME [ "/sys/fs/cgroup" ]
#### CMD ["/usr/sbin/init"]

# 
#### docker build --rm -t local/c8-systemd .
