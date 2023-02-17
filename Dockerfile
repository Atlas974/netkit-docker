FROM debian:jessie

ARG NETKIT_CORE_VER="2.8"
ARG NETKIT_FS_VER="5.2"
ARG NETKIT_KERN_VER="2.8"

ARG ROOT_PASS="toor"


RUN apt update && apt install -y --force-yes \
    curl bzip2 \
    lsof \
    xterm \
    lib32z1 lib32ncurses5 libc6-i386

RUN curl -fsSL -kO "https://www.netkit.org/assets/netkit/netkit-${NETKIT_CORE_VER}.tar.bz2" \
    && curl -fsSL -kO "https://www.netkit.org/assets/netkit/netkit-filesystem-i386-F${NETKIT_FS_VER}.tar.bz2" \
    && curl -fsSL -kO "https://www.netkit.org/assets/netkit/netkit-kernel-i386-K${NETKIT_KERN_VER}.tar.bz2"

RUN tar -xjSf "netkit-${NETKIT_CORE_VER}.tar.bz2" \
    && tar -xjSf "netkit-filesystem-i386-F${NETKIT_FS_VER}.tar.bz2" \
    && tar -xjSf "netkit-kernel-i386-K${NETKIT_KERN_VER}.tar.bz2" \
    && mv netkit /opt/ \
    && rm netkit-*

COPY netkit.sh /etc/profile.d/

RUN apt update && apt install -y --force-yes openssh-server && \
    sed -ri 's/#?(PermitRootLogin) .*/\1 yes/' /etc/ssh/sshd_config && \
    sed -ri 's/#?(PasswordAuthentication) .*/\1 yes/' /etc/ssh/sshd_config && \
    sed -i '/X11Forwarding/a X11UseLocalhost no' /etc/ssh/sshd_config && \
    echo "root:$ROOT_PASS" | chpasswd

EXPOSE 22
CMD service ssh start -D

