#!/usr/bin/env bash
set -e

FORCE_REINIT_CONFIG=${FORCE_REINIT_CONFIG:=false}
APP_UID=${APP_UID:=1000}
APP_GID=${APP_GID:=1000}
APP_USER_NAME=${APP_USER_NAME:=admin}
APP_USER_PASSWD=${APP_USER_PASSWD:=admin}
APP_CREATE_MASK=${APP_CREATE_MASK:=0660}
APP_DIRECTORY_MASK=${APP_DIRECTORY_MASK:=0770}
if [ -f "$SAMBA_SOURCE_DIR/Initialized" ] && [ "$FORCE_REINIT_CONFIG" = false ]; then
	echo "[] Skip initializing"
else
	echo "[] Creating initial data ..."	
	chmod 770 $SAMBA_SOURCE_DIR/eventscripts/*.sh || true
	echo "[] Running on_pre_init.sh ..."
		. $SAMBA_SOURCE_DIR/eventscripts/on_pre_init.sh || true
	echo "[] Done."


	echo "[] Setting UID/GID ..."
		groupadd $APP_USER_NAME || true
		useradd $APP_USER_NAME -g $APP_USER_NAME || true
		groupmod -o -g $APP_GID $APP_USER_NAME || true
		usermod -o -u $APP_UID $APP_USER_NAME || true
	echo "[] Done."
	
	echo "[] Coping configs ..."	
		cp $SAMBA_SOURCE_DIR/smb.conf $SAMBA_CONF_PATH || true
		
		echo "" >> $SAMBA_CONF_PATH || true
		echo "" >> $SAMBA_CONF_PATH || true
		echo "[$APP_USER_NAME]" >> $SAMBA_CONF_PATH || true
		echo "path = $SAMBA_DATA_PATH" >> $SAMBA_CONF_PATH || true
		echo "available = yes" >> $SAMBA_CONF_PATH || true
		echo "valid users = $APP_USER_NAME" >> $SAMBA_CONF_PATH || true
		echo "read only = no" >> $SAMBA_CONF_PATH || true
		echo "browseable = yes" >> $SAMBA_CONF_PATH || true
		echo "public = no" >> $SAMBA_CONF_PATH || true
		echo "writeable = yes" >> $SAMBA_CONF_PATH || true
		echo "guest ok = no" >> $SAMBA_CONF_PATH || true
		echo "create mask = $APP_CREATE_MASK" >> $SAMBA_CONF_PATH || true
		echo "directory mask = $APP_DIRECTORY_MASK" >> $SAMBA_CONF_PATH || true
	echo "Done ."
	
	echo "[] Fixing permision ..."
		chown -R $APP_USER_NAME:$APP_USER_NAME $SAMBA_CONF_PATH
		chown $APP_USER_NAME:$APP_USER_NAME $SAMBA_DATA_PATH
		chown $APP_USER_NAME:$APP_USER_NAME $SAMBA_DATA_PATH/data
	echo "Done."
	
	echo "[] Setting password: ${APP_USER_NAME}"	
		echo -e "$APP_USER_PASSWD\n$APP_USER_PASSWD\n" | smbpasswd -a $APP_USER_NAME || true
	echo "[] Done."
	

	touch $SAMBA_SOURCE_DIR/Initialized || true
	echo "[] Running on_post_init.sh ..."
		. $SAMBA_SOURCE_DIR/eventscripts/on_post_init.sh || true
	echo "[] Done."	
	echo "[] Initialize complete."
fi

echo "[] Running on_run.sh ..."
. $SAMBA_SOURCE_DIR/eventscripts/on_run.sh || true
echo "[] Done."	
echo "[] Run smbd ..."
ionice -c 3 smbd -FS --no-process-group --configfile="${SAMBA_CONF_PATH}"
echo "[] Done."	

