#!/usr/bin/env bash

setsid ./rclone -v sync /shares/Atual backup-nas:/BACKUPS-NAS-SEAGATE/20170904 --log-file /root/logs/Atual.log &>/dev/null

setsid ./rclone -v sync /shares/NONAME\ \(USB\)\ #5/PROJETOS-CLIENTES-3D-TRABALHOS-CSM_2016_Backup/2017_08_07-14_41_16_B1 backup-nas:/BACKUPS-NAS-SEAGATE/2017_08_07-14_41_16_B1 --log-file /root/logs/ExtUSB.log &>/dev/null

# MZ Notebook
setsid rclone -v sync /home/casademarcas/PhpStormProjects googledrive-mz:_CASADEMARCAS-PHPSTORMPROJECTS-MZ --log-file /home/casademarcas/.config/rclone/logs/phpStormProjects.log &>/dev/null