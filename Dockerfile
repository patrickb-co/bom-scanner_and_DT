FROM local/c8-systemd

WORKDIR /
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin
RUN cd /etc/yum.repos.d/ && sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* && yum update -y
RUN yum install git -y 
RUN git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew \
&& mkdir ~/.linuxbrew/bin \
&& ln -s ../Homebrew/bin/brew ~/.linuxbrew/bin \
&& eval $(~/.linuxbrew/bin/brew shellenv) \
&& brew --version \
&& yum groupinstall 'Development Tools' -y \
&& brew install gcc \
&& brew install cyclonedx/cyclonedx/cyclonedx-cli \
&& cyclonedx --version
RUN dnf module install nodejs:12 -y && npm i @cyclonedx/bom -y
RUN dnf install python3 -y && pip3 install cyclonedx-python-lib
RUN dnf install dotnet-sdk-6.0 -y && dnf install aspnetcore-runtime-6.0 && dotnet tool install --global CycloneDX --version 2.3.0 && export PATH="$PATH:/root/.dotnet/tools" && touch ~/.bash_profile && export PATH="$PATH:/root/.dotnet/tools" 

RUN yum -y install httpd; yum clean all; systemctl enable httpd.service

CMD ["/usr/sbin/init"]



ENV PATH=~/.linuxbrew/bin:~/.linuxbrew/sbin:$PATH

RUN mkdir /sbom-java && cd sbom-java
RUN echo "the volume works" > /sbom-java/works
RUN cd sbom-java && git clone https://github.com/apache/nifi.git
RUN cd /
RUN syft /sbom-java/nifi -o json > syft_output_java.json

RUN mkdir /sbom-python && cd sbom-python
RUN echo "the volume works" > /sbom-python/works
RUN cd sbom-python && git clone https://github.com/ansible/ansible.git
RUN cd /
RUN syft /sbom-python/ansible -o json > syft_output_python.json

RUN mkdir /sbom-dotnet && cd sbom-dotnet
RUN echo "the volume works" > /sbom-dotnet/works
RUN cd sbom-dotnet && git clone https://github.com/NuGet/NuGetGallery.git
RUN cd /
RUN syft /sbom-dotnet/NuGetGallery -o json > syft_output_dotnet.json

VOLUME [ "/sbom-java" ]
VOLUME [ "/sbom-python" ]
VOLUME [ "/sbom-dotnet" ]

EXPOSE 80 8080 8081
