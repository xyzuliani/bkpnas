#!/bin/bash
# ----------------------------------------------------------------------------------------
# bkpnas4.sh - Script shell to manage backups (with Rclone) in SEAGATE NAS and Cron Jobs
# Based: Rclone - https://rclone.org
# Autor: Marco Zuliani (xyzuliani@gmail.com)
# Date: Nov/2017
# Version: 4.0.0
# Sample: $ ./bkpnas4.sh VOLUME_1.log VOLUME_2.log
# ----------------------------------------------------------------------------------------

# Sample on development local test:
# ./bkpnas4.sh _CASADEMARCAS-PACKAGES-MZ.log _CASADEMARCAS-PROJECTS-MZ.log

ENTRACE1=$1;
ENTRACE2=$2;

TGT1=${ENTRACE1%.*};
TGT2=${ENTRACE2%.*};

#DPATH="/home/casademarcas/.config/rclone/logs";
DPATH="/root/logs";


if [ ! -w $DPATH"/"$ENTRACE1 ]
then
    touch $DPATH"/"$ENTRACE1;
fi

if [ ! -w $DPATH"/"$ENTRACE2 ]
then
    touch $DPATH"/"$ENTRACE2;
fi

if [ ! -w $DPATH"/cron-"$ENTRACE1 ]
then
    touch $DPATH"/cron-"$ENTRACE1;
fi

if [ ! -w $DPATH"/cron-"$ENTRACE2 ]
then
    touch $DPATH"/cron-"$ENTRACE2;
fi


if [ ! -w $DPATH"/"$ENTRACE1 ]
then
    echo "File 1 does not exist or not writable";
    exit 0
fi

if [ ! -w $DPATH"/"$ENTRACE2 ]
then
    echo "File 2 does not exist or not writable";
    exit 0
fi

if [ ! -w $DPATH"/cron-"$ENTRACE1 ]
then
    echo "File 3 does not exist or not writable";
    exit 0
fi

if [ ! -w $DPATH"/cron-"$ENTRACE2 ]
then
    echo "File 4 does not exist or not writable";
    exit 0
fi


AGORA=`date +%Y-%m-%d_%H_%M`;

RNUMPID=`pgrep rclone | sed ':a;N;$!ba;s/\n/,/g'`

onepid=$(awk '/./{line=$0} END {print line;}' $DPATH"/cron-"$ENTRACE1);
twopid=$(awk '/./{line=$0} END {print line;}' $DPATH"/cron-"$ENTRACE2);

#GDRIVE="googledrive-mz";
GDRIVE="backup-nas";

#source1="/home/casademarcas/GoogleDrive/$TGT1";
#destiny1="test/$TGT1";
source1="/shares/$TGT1";
destiny1="/BACKUPS-SYNC-NAS-DAILY/$TGT1";

#source2="/home/casademarcas/GoogleDrive/$TGT2";
#destiny2="test/$TGT2";
source2="/shares/$TGT2";
destiny2="/BACKUPS-SYNC-NAS-DAILY/$TGT2";

if test -n "$RNUMPID"
then

    PID1="${onepid##*,}";
    PID2="${twopid##*,}";

    if [[ $RNUMPID == *"$PID1"* ]]; then

        echo "$TGT1,$AGORA,$PID1" >> $DPATH"/cron-"$ENTRACE1;
    else

        printf "\n\n### $AGORA ###\n\n" >> $DPATH"/"$ENTRACE1;

        #setsid /root/./rclone -v sync /shares/VOLUME_1 backup-nas:/BACKUPS-SYNC-NAS-DAILY/VOLUME_1 --log-file /root/logs/VOLUME_1.log &>/dev/null
        setsid rclone -v sync $source1 $GDRIVE":"$destiny1 --log-file $DPATH"/"$ENTRACE1 &
        AID1=$!

        echo "$TGT1,$AGORA,$AID1" >> $DPATH"/cron-"$ENTRACE1;
    fi

    if [[ $RNUMPID == *"$PID2"* ]]; then

        echo "$TGT2,$AGORA,$PID2" >> $DPATH"/cron-"$ENTRACE2;
    else

        printf "\n\n### $AGORA ###\n\n" >> $DPATH"/"$ENTRACE2;

        setsid rclone -v sync $source2 $GDRIVE":"$destiny2 --log-file $DPATH"/"$ENTRACE2 &
        AID2=$!

        echo "$TGT2,$AGORA,$AID2" >> $DPATH"/cron-"$ENTRACE2;
    fi

else

    printf "\n\n### $AGORA ###\n\n" >> $DPATH"/"$ENTRACE1;

    setsid rclone -v sync $source1 $GDRIVE":"$destiny1 --log-file $DPATH"/"$ENTRACE1 &
    AID1=$!

    echo "$TGT1,$AGORA,$AID1" >> $DPATH"/cron-"$ENTRACE1;


    printf "\n\n### $AGORA ###\n\n" >> $DPATH"/"$ENTRACE2;

    setsid rclone -v sync $source2 $GDRIVE":"$destiny2 --log-file $DPATH"/"$ENTRACE2 &
    AID2=$!

    echo "$TGT2,$AGORA,$AID2" >> $DPATH"/cron-"$ENTRACE2;
fi
