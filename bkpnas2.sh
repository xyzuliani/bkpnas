#!/bin/bash
# ----------------------------------------------------------------------------------------
# bkpnas2.sh - Script shell to manage backups (with Gdrive) in SEAGATE NAS and Cron Jobs
# Based on Gdrive: https://github.com/prasmussen/gdrive
# Autor: Marco Zuliani (xyzuliani@gmail.com)
# Date: Set/2017
# Version: 2.0.0
# Sample: $ ./bkpnas2.sh Atual.log ExtUSB.log
# ----------------------------------------------------------------------------------------

ENTRACE1=$1;
ENTRACE2=$2;

TGT1=${ENTRACE1%.*};
TGT2=${ENTRACE2%.*};

DPATH="/root/logs";

one=$(awk '/./{line=$0} END {print line;}' $DPATH"/"$ENTRACE1);
two=$(awk '/./{line=$0} END {print line;}' $DPATH"/"$ENTRACE2);

AGORA=`date +%Y-%m-%d_%H_%M`;

#RNUMPID=`pgrep gdrive | paste -sd "," -`; # not work on NAS
RNUMPID=`pgrep gdrive | sed ':a;N;$!ba;s/\n/,/g'`

onepid=$(awk '/./{line=$0} END {print line;}' $DPATH"/cron"$ENTRACE1);
twopid=$(awk '/./{line=$0} END {print line;}' $DPATH"/cron"$ENTRACE2);

# ----------------------------------------------------------------------------------------
# STARTING ACTIONS
# ----------------------------------------------------------------------------------------

if test -n "$RNUMPID"
then

    PID1="${onepid##*,}";
    PID2="${twopid##*,}";

    # First PID
    if [[ $RNUMPID == *"$PID1"* ]]; then

        echo "$TGT1,$AGORA,$PID1" >> $DPATH"/cron"$ENTRACE1;
        # exit 0;
    else

        if [[ $one != *"finished"* ]]; then

            printf "\n\n### $AGORA ###\n\n" >> $DPATH"/"$ENTRACE1;

            /root/./gdrive sync upload --keep-local --timeout 0 /shares/Atual 0B2748e8sENkZN3ZVTUFiaG1PaDA >> $DPATH"/"$ENTRACE1 &
            AID1=$!
            echo "$TGT1,$AGORA,$AID1" >> $DPATH"/cron"$ENTRACE1;
        fi
    fi

    # Second PID
    if [[ $RNUMPID == *"$PID2"* ]]; then

        echo "$TGT2,$AGORA,$PID2" >> $DPATH"/cron"$ENTRACE2;
        # exit 0;
    else

        if [[ $two != *"finished"* ]]; then

            printf "\n\n### $AGORA ###\n\n" >> $DPATH"/"$ENTRACE2;

            /root/./gdrive sync upload --keep-local --timeout 0 /shares/NONAME\ \(USB\)\ #5/PROJETOS-CLIENTES-3D-TRABALHOS-CSM_2016_Backup/2017_08_07-14_41_16_B1 0B2748e8sENkZZW5TbFFUNnRSZkU >> $DPATH"/"$ENTRACE2 &
            AID2=$!
            echo "$TGT2,$AGORA,$AID2" >> $DPATH"/cron"$ENTRACE2;
        fi
    fi

else

    if [[ $one != *"finished"* ]]; then

        printf "\n\n### $AGORA ###\n\n" >> $DPATH"/"$ENTRACE1;

        /root/./gdrive sync upload --keep-local --timeout 0 /shares/Atual 0B2748e8sENkZN3ZVTUFiaG1PaDA >> $DPATH"/"$ENTRACE1 &
        AID1=$!
        echo "$TGT1,$AGORA,$AID1" >> $DPATH"/cron"$ENTRACE1;
    fi

    if [[ $two != *"finished"* ]]; then

        printf "\n\n### $AGORA ###\n\n" >> $DPATH"/"$ENTRACE2;

        /root/./gdrive sync upload --keep-local --timeout 0 /shares/NONAME\ \(USB\)\ #5/PROJETOS-CLIENTES-3D-TRABALHOS-CSM_2016_Backup/2017_08_07-14_41_16_B1 0B2748e8sENkZZW5TbFFUNnRSZkU >> $DPATH"/"$ENTRACE2 &
        AID2=$!
        echo "$TGT2,$AGORA,$AID2" >> $DPATH"/cron"$ENTRACE2;
    fi
fi