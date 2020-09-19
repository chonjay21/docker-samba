FROM alpine:latest

# Labels
LABEL Description "Our goal is to create a simple, consistent, customizable and convenient image using official image" \
	  maintainer "https://github.com/chonjay21"

# Environment variables
ENV SAMBA_SOURCE_DIR=/sources/samba \
	SAMBA_DATA_PATH=/home/samba \
	SAMBA_CONF_PATH=/etc/samba/smb.conf
	
# install apps... (shadow for usermod/groupmode)
RUN apk update && apk upgrade; \
	apk add --no-cache \
	shadow \
	bash \
	tzdata \
	samba-common-tools \
	samba \
	curl

ADD sources/ $SAMBA_SOURCE_DIR/

# set permission
RUN chmod 770 $SAMBA_SOURCE_DIR/*.sh; \
	chmod 770 $SAMBA_SOURCE_DIR/eventscripts/*.sh; \
	mkdir -p $SAMBA_DATA_PATH/data

# Expose Samba ports
EXPOSE 137 138 139 445

ENTRYPOINT $SAMBA_SOURCE_DIR/entrypoint.sh