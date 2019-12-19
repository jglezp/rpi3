#!/bin/bash
# Es necesario tener configurado rclone para que pueda sincronizar con tu Google Drive
# Ejemplo: ./backup.sh /root /srv
BACKUP="/backup"
NOW=$(date +"%Y%m%d-%H%M")
TAR_NAME=$BACKUP/rpi.$NOW.tar.gz
DEST="drive:rpi"

for folder in $@
do
  rsync -ahr --delete $folder $BACKUP > /dev/null 2>&1
done

tar --exclude='$BACKUP/rpi*' -czvf $TAR_NAME $BACKUP > /dev/null 2>&1
rclone copy $TAR_NAME $DEST

# Crontab de root con todos los crons del sistema
rclone copy /var/spool/cron/crontabs/root $DEST/crontab

# Limpia el backup local y los rota en Google Drive
rm $TAR_NAME

today=$(echo $NOW | cut -d"-" -f1)
backup_rotation=6
day_rotate=$(date --date="$today -$backup_rotation day" +%Y%m%d)

for old_backups in $(rclone lsf $DEST | grep rpi)
do
  if [ `echo $old_backups | cut -d"." -f2 | cut -d"-" -f1` -le $day_rotate ]; then
    rclone delete $DEST/$old_backups
  fi
done
