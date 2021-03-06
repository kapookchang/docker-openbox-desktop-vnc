FROM fedora:24
MAINTAINER laurynas@alekna.org 

WORKDIR /root
EXPOSE 5900 

ENV HOME /root
ENV GEOMETRY 1024x768
ENV DEPTH 16
ENV TZ Etc/UTC

RUN dnf -y update; \
    dnf -y install tightvnc-server openbox dbus-x11 mate-terminal tint2 pcmanfm which dejavu-sans-fonts dejavu-sans-mono-fonts; \
    dnf clean all; \
    dbus-uuidgen > /etc/machine-id

ADD xinitrc /etc/X11/xinit/xinitrc
ADD .config /root/.config
ADD .bashrc /root/.bashrc
ADD xstartup /root/.vnc/xstartup

RUN echo "root" | vncpasswd -f > /root/.vnc/passwd; \
    chmod 600 /root/.vnc/passwd

CMD ln -sf /usr/share/zoneinfo/$TZ /etc/localtime; vncserver -kill :0; vncserver :0 -geometry $GEOMETRY -depth $DEPTH; tail -f /root/.vnc/*.log
