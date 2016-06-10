FROM centos:7

# Get Ansible
RUN yum install -y bash curl git openssh python unzip > /dev/null
RUN rpm -iUvh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
  && yum -y update > /dev/null \
  && yum install -y gcc openssl-devel python-devel libffi-devel python-pip \
  && git clone https://github.com/CiscoCloud/mantl /mantl \
	&& pip install -r /mantl/requirements.txt \
	&& yum remove -y python-pip python-devel gcc openssl-devel

# Get terraform
ENV TERRAFORM_VERSION 0.6.16
RUN curl -sSLo /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip -d /usr/local/bin /tmp/terraform.zip && \
    rm -f /tmp/terraform.zip

ENV TERRAFORM_STATE $MANTL_CONFIG_DIR/terraform.tfstate
ENV MANTL_CONFIG_DIR /local
VOLUME /local
VOLUME /root/.ssh
WORKDIR /mantl

ENTRYPOINT ["/usr/bin/ssh-agent", "-t", "3600", "/bin/sh", "-c"]
