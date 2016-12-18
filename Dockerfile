# Builds a docker gui image
FROM hurricane/dockergui:x11rdp1.3

MAINTAINER larizzo

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

# Set environment variables

# User/Group Id gui app will be executed as default are 99 and 100
ENV USER_ID=99
ENV GROUP_ID=100

# Gui App Name default is "GUI_APPLICATION"
ENV APP_NAME="rdp-dev"

# Default resolution, change if you like
ENV WIDTH=1400
ENV HEIGHT=1050

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

ADD https://dl.google.com/linux/linux_signing_key.pub /tmp/

RUN \
#########################################
##    REPOSITORIES AND DEPENDENCIES    ##
#########################################
echo 'deb http://archive.ubuntu.com/ubuntu trusty main universe restricted' > /etc/apt/sources.list && \
echo 'deb http://archive.ubuntu.com/ubuntu trusty-updates main universe restricted' >> /etc/apt/sources.list && \
echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list && \
echo 'deb http://dl.google.com/linux/chrome-remote-desktop/deb/ stable main' >> /etc/apt/sources.list && \
apt-key add /tmp/linux_signing_key.pub && \


# Install packages needed for app
export DEBCONF_NONINTERACTIVE_SEEN=true DEBIAN_FRONTEND=noninteractive && \
apt-get update && \
apt-get install -y \
google-chrome-stable && \
apt-get cleanup

#########################################
##          GUI APP INSTALL            ##
#########################################

# Install steps for X app


# Copy X app start script to right location
COPY startapp.sh /startapp.sh

#########################################
##         EXPORTS AND VOLUMES         ##
#########################################

# Place whater volumes and ports you want exposed here:
VOLUME ["/config"]
EXPOSE 3389 8080
