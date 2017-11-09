#!/bin/bash
# ----------------------------------------------------------------------------------------
# bkpnas3.2.sh - Script shell to manage backups (with Rclone) in SEAGATE NAS and Cron Jobs
# Rclone: https://rclone.org
# Autor: Marco Zuliani (xyzuliani@gmail.com)
# Date: Set/2017
# Version: 3.2.0
# Sample: $ ./bkpnas3.2.sh Atual.log ExtUSB.log
# ----------------------------------------------------------------------------------------

ENTRACE1=$1;
ENTRACE2=$2;

TGT1=${ENTRACE1%.*};
TGT2=${ENTRACE2%.*};

DPATH="/root/logs";

one=$(awk '/./{line=$0} END {print line;}' $DPATH"/"$ENTRACE1);
two=$(awk '/./{line=$0} END {print line;}' $DPATH"/"$ENTRACE2);

AGORA=`date +%Y-%m-%d_%H_%M`;

RNUMPID=`pgrep rclone | sed ':a;N;$!ba;s/\n/,/g'`

onepid=$(awk '/./{line=$0} END {print line;}' $DPATH"/cron"$ENTRACE1);
twopid=$(awk '/./{line=$0} END {print line;}' $DPATH"/cron"$ENTRACE2);

if test -n "$RNUMPID"
then

    PID1="${onepid##*,}";
    PID2="${twopid##*,}";

    if [[ $RNUMPID == *"$PID1"* ]]; then

        echo "$TGT1,$AGORA,$PID1" >> $DPATH"/cron"$ENTRACE1;
    else

        if [[ $one != *"finished"* ]]; then

            printf "\n\n### $AGORA ###\n\n" >> $DPATH"/"$ENTRACE1;

            setsid /root/./rclone -v sync /shares/Atual backup-nas:/BACKUPS-NAS-SEAGATE/20170904 --log-file $DPATH"/"$ENTRACE1 &
            AID1=$!
            echo "$TGT1,$AGORA,$AID1" >> $DPATH"/cron"$ENTRACE1;
        fi
    fi

    if [[ $RNUMPID == *"$PID2"* ]]; then

        echo "$TGT2,$AGORA,$PID2" >> $DPATH"/cron"$ENTRACE2;
    else

        if [[ $two != *"finished"* ]]; then

            printf "\n\n### $AGORA ###\n\n" >> $DPATH"/"$ENTRACE2;

            setsid /root/./rclone -v sync /shares/NONAME\ \(USB\)\ #5/PROJETOS-CLIENTES-3D-TRABALHOS-CSM_2016_Backup/2017_08_07-14_41_16_B1 backup-nas:/BACKUPS-NAS-SEAGATE/2017_08_07-14_41_16_B1 --log-file $DPATH"/"$ENTRACE2 &
            AID2=$!
            echo "$TGT2,$AGORA,$AID2" >> $DPATH"/cron"$ENTRACE2;
        fi
    fi

else

    if [[ $one != *"finished"* ]]; then

        printf "\n\n### $AGORA ###\n\n" >> $DPATH"/"$ENTRACE1;

        setsid /root/./rclone -v sync /shares/Atual backup-nas:/BACKUPS-NAS-SEAGATE/20170904 --log-file $DPATH"/"$ENTRACE1 &
        AID1=$!
        echo "$TGT1,$AGORA,$AID1" >> $DPATH"/cron"$ENTRACE1;
    fi

    if [[ $two != *"finished"* ]]; then

        printf "\n\n### $AGORA ###\n\n" >> $DPATH"/"$ENTRACE2;

        setsid /root/./rclone -v sync /shares/NONAME\ \(USB\)\ #5/PROJETOS-CLIENTES-3D-TRABALHOS-CSM_2016_Backup/2017_08_07-14_41_16_B1 backup-nas:/BACKUPS-NAS-SEAGATE/2017_08_07-14_41_16_B1 --log-file $DPATH"/"$ENTRACE2 &
        AID2=$!
        echo "$TGT2,$AGORA,$AID2" >> $DPATH"/cron"$ENTRACE2;
    fi
fi
