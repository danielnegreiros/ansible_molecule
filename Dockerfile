# Molecule managed
FROM quay.io/centos/centos:stream8
ENV ANSIBLE_USER=ansible DEPLOY_GROUP=deployer
ENV SUDO_GROUP={{'sudo' if 'debian' in item.image else 'wheel' }}

RUN if [ $(command -v apt-get) ]; then export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y python3 sudo bash ca-certificates iproute2 python3-apt aptitude && apt-get clean && rm -rf /var/lib/apt/lists/*; \
    elif [ $(command -v dnf) ]; then dnf makecache && dnf --assumeyes install /usr/bin/python3 /usr/bin/python3-config /usr/bin/dnf-3 sudo bash iproute && dnf clean all; \
    elif [ $(command -v yum) ]; then yum makecache fast && yum install -y /usr/bin/python /usr/bin/python2-config sudo yum-plugin-ovl bash iproute && sed -i 's/plugins=0/plugins=1/g' /etc/yum.conf && yum clean all; \
    elif [ $(command -v zypper) ]; then zypper refresh && zypper install -y python3 sudo bash iproute2 && zypper clean -a; \
    elif [ $(command -v apk) ]; then apk update && apk add --no-cache python3 sudo bash ca-certificates; \
    elif [ $(command -v xbps-install) ]; then xbps-install -Syu && xbps-install -y python3 sudo bash ca-certificates iproute2 && xbps-remove -O; fi


RUN set -xe \
  && groupadd -r ${ANSIBLE_USER} \
  && groupadd -r ${DEPLOY_GROUP} \
  && useradd -m -g ${ANSIBLE_USER} ${ANSIBLE_USER} \
  && usermod -aG ${SUDO_GROUP} ${ANSIBLE_USER} \
  && usermod -aG ${DEPLOY_GROUP} ${ANSIBLE_USER} \
  && sed -i "/^%${SUDO_GROUP}/s/ALL\$/NOPASSWD:ALL/g" /etc/sudoers
