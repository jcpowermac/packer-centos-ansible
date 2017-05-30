FROM fedora:latest
MAINTAINER Joseph Callen <jcpowermac@gmail.com>

RUN dnf -y install qemu-kvm git wget qemu  edk2-ovmf \
                   ansible unzip python2-requests && \
    dnf clean all

RUN mkdir /opt/packer && \
    cd /opt/packer && \
    wget -nv $(python -c 'import requests;version = requests.get("https://api.github.com/repos/mitchellh/packer/tags").json()[0]["name"].replace("v","");print "https://releases.hashicorp.com/packer/%s/packer_%s_linux_amd64.zip" % (version,version)') -O /opt/packer/packer.zip && \
    unzip packer.zip && \ 
    mkdir -p /build/kickstart 

COPY . /opt/centos-artifacts


ENV USER=root

VOLUME /build
WORKDIR /build
ENTRYPOINT ["/opt/packer/packer"]
CMD ["build", "/opt/centos-artifacts/centos7.json"]
EXPOSE 5900

