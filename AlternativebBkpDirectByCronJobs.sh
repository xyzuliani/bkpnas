#!/usr/bin/env bash

# ATUAL
# setsid ./rclone -v sync /shares/Atual backup-nas:/BACKUPS-NAS-SEAGATE/20170904 --log-file /root/logs/Atual.log &>/dev/null

# EXTUSB
# setsid ./rclone -v sync /shares/NONAME\ \(USB\)\ #5/PROJETOS-CLIENTES-3D-TRABALHOS-CSM_2016_Backup/2017_08_07-14_41_16_B1 backup-nas:/BACKUPS-NAS-SEAGATE/2017_08_07-14_41_16_B1 --log-file /root/logs/ExtUSB.log &>/dev/null

# TARES
# setsid ./rclone -v sync /shares/NONAME\ \(USB\)\ #5/BACKUP-NAS-20170831 backup-nas:/BACKUPS-NAS-SEAGATE/20170831 --log-file /root/logs/TaresExtUSB.log &>/dev/null

# EXTUSB-2
# setsid ./rclone -v sync /shares/NONAME\ \(USB\)\ #5/20171018/CSM-CABANA-SIGNUS-BRAHMA-WICKBOLD-OPTUM-NEXT-AMIL-AMILSAÚDE-SEMPRE_TE..._Backup/2017_10_18-14_45_39_B1 backup-nas:/BACKUPS-NAS-SEAGATE/2017_10_18-14_45_39_B1 --log-file /root/logs/ExtUSB-2.log &>/dev/null

# MZ Notebook - PhpStormProjects
setsid rclone -v sync /home/casademarcas/PhpStormProjects googledrive-mz:_CASADEMARCAS-PHPSTORMPROJECTS-MZ --log-file /home/casademarcas/.config/rclone/logs/PhpStormProjects.log &>/dev/null

# MZ Notebook - _CASADEMARCAS-PACKAGES-MZ
setsid rclone -v sync /home/casademarcas/GoogleDrive/_CASADEMARCAS-PACKAGES-MZ googledrive-mz:_CASADEMARCAS-PACKAGES-MZ --log-file /home/casademarcas/.config/rclone/logs/_CASADEMARCAS-PACKAGES-MZ.log &>/dev/null

# MZ Notebook - _CASADEMARCAS-SHARED-WITH-MZ
setsid rclone -v sync /home/casademarcas/GoogleDrive/_CASADEMARCAS-SHARED-WITH-MZ googledrive-mz:_CASADEMARCAS-SHARED-WITH-MZ --log-file /home/casademarcas/.config/rclone/logs/_CASADEMARCAS-SHARED-WITH-MZ.log &>/dev/null

# MZ Notebook - _CASADEMARCAS-PROJECTS-MZ
setsid rclone -v sync /home/casademarcas/GoogleDrive/_CASADEMARCAS-PROJECTS-MZ googledrive-mz:_CASADEMARCAS-PROJECTS-MZ --log-file /home/casademarcas/.config/rclone/logs/_CASADEMARCAS-PROJECTS-MZ.log &>/dev/null