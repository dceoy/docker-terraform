FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

ADD https://bootstrap.pypa.io/get-pip.py /tmp/get-pip.py
ADD https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip /tmp/awscliv2.zip
ADD https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh /tmp/install_tflint.sh
ADD https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh /tmp/install_tfsec.sh
ADD https://raw.githubusercontent.com/dceoy/print-github-tags/master/print-github-tags /usr/local/bin/print-github-tags

RUN set -e \
      && ln -sf bash /bin/sh \
      && ln -s python3 /usr/bin/python \
      && chmod +x /usr/local/bin/print-github-tags

RUN set -e \
      && apt-get -y update \
      && apt-get -y dist-upgrade \
      && apt-get -y install --no-install-recommends --no-install-suggests \
        apt-transport-https ca-certificates curl python3 python3-distutils unzip \
      && apt-get -y autoremove \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

RUN set -eo pipefail \
      && print-github-tags --release --latest --tar tfutils/tfenv \
        | xargs curl -SL -o /tmp/tfenv.tar.gz \
      && tar xvf /tmp/tfenv.tar.gz -C /opt/ --remove-files \
      && mv /opt/tfenv-* /opt/tfenv \
      && /opt/tfenv/bin/tfenv install latest \
      && /opt/tfenv/bin/tfenv use latest

ENV PATH /opt/tfenv/bin:${PATH}

RUN set -e \
      && bash /tmp/install_tflint.sh \
      && bash /tmp/install_tfsec.sh \
      && rm -f /tmp/install_tflint.sh /tmp/install_tfsec.sh

RUN set -e \
      && unzip /tmp/awscliv2.zip -d /tmp \
      && /tmp/aws/install \
      && rm -rf /tmp/awscliv2.zip /tmp/aws

RUN set -e \
      && /usr/bin/python3 /tmp/get-pip.py \
      && pip install -U --no-cache-dir pip \
      && pip install -U --no-cache-dir cfn-lint yamllint

ENTRYPOINT ["/opt/tfenv/bin/terraform"]
