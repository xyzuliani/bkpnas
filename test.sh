#!/bin/bash
# ----------------------------------------------------------------------------------------
# bkpnas4.3.sh - Script shell to manage backups (with Rclone) in SEAGATE NAS and Cron Jobs
# Based: Rclone - https://rclone.org
# Autor: Marco Zuliani (xyzuliani@gmail.com)
# Date: Mar/2018
# Version: 4.3.0
# Sample: $ ./bkpnas4.3.sh VOLUME_1.log VOLUME_2.log BACKUPS-SYNC-NAS-DAILY
# OR
# Sample: $ ./bkpnas4.3.sh VOLUME_1.log VOLUME_2.log BACKUPS-AGENDADOS-BY-NAS BKP_
# ----------------------------------------------------------------------------------------

ENTRACE1=$1;
ENTRACE2=$2;
DESTPATH=$3;
BKFOLDER=$4;

TGT1=${ENTRACE1%.*};
TGT2=${ENTRACE2%.*};

LPATH="/root/logs";

if [ ! -w $LPATH"/"$BKFOLDER$ENTRACE1 ]
then
    touch $LPATH"/"$BKFOLDER$ENTRACE1;
fi

if [ ! -w $LPATH"/"$BKFOLDER$ENTRACE2 ]
then
    touch $LPATH"/"$BKFOLDER$ENTRACE2;
fi

if [ ! -w $LPATH"/cron-"$BKFOLDER$ENTRACE1 ]
then
    touch $LPATH"/cron-"$BKFOLDER$ENTRACE1;
fi

if [ ! -w $LPATH"/cron-"$BKFOLDER$ENTRACE2 ]
then
    touch $LPATH"/cron-"$BKFOLDER$ENTRACE2;
fi

if [ ! -w $LPATH"/"$BKFOLDER$ENTRACE1 ]
then
    echo "File 1 does not exist or not writable";
    exit 0
fi

if [ ! -w $LPATH"/"$BKFOLDER$ENTRACE2 ]
then
    echo "File 2 does not exist or not writable";
    exit 0
fi

if [ ! -w $LPATH"/cron-"$BKFOLDER$ENTRACE1 ]
then
    echo "File 3 does not exist or not writable";
    exit 0
fi

if [ ! -w $LPATH"/cron-"$BKFOLDER$ENTRACE2 ]
then
    echo "File 4 does not exist or not writable";
    exit 0
fi

AGORA=`date +%Y-%m-%d_%H_%M`;

RNUMPID=`pgrep rclone | sed ':a;N;$!ba;s/\n/,/g'`

printf $RNUMPID"\n";

onepid=$(awk '/./{line=$0} END {print line;}' $LPATH"/cron-"$BKFOLDER$ENTRACE1);
twopid=$(awk '/./{line=$0} END {print line;}' $LPATH"/cron-"$BKFOLDER$ENTRACE2);

GDRIVE="backup-nas";

source1="/shares/$TGT1";
destiny1="/$DESTPATH/$BKFOLDER$TGT1";

source2="/shares/$TGT2";
destiny2="/$DESTPATH/$BKFOLDER$TGT2";

if [ -n "$RNUMPID" ]
then

    PID1="${onepid##*,}";
    PID2="${twopid##*,}";

    #echo $PID1"|"$PID2;
    #exit;

    if [ -n "$PID1" ] && [[ $RNUMPID == *"$PID1"* ]]; then

	echo "true111";
	exit;

        echo "$BKFOLDER$TGT1,$AGORA,111" >> $LPATH"/test-cron-"$BKFOLDER$ENTRACE1;
    else

	echo "false222";
	
        #printf "\n\n### $AGORA ###\n\n" >> $LPATH"/test-"$BKFOLDER$ENTRACE1;
	#echo "$BKFOLDER$TGT1,$AGORA,222" >> $LPATH"/test-cron-"$BKFOLDER$ENTRACE1;
    fi

    if [ -n "$PID2" ] && [[ $RNUMPID == *"$PID2"* ]]; then

	echo "true333";
	exit;

        echo "$BKFOLDER$TGT2,$AGORA,333" >> $LPATH"/test-cron-"$BKFOLDER$ENTRACE2;
    else

	echo "false444";

        #printf "\n\n### $AGORA ###\n\n" >> $LPATH"/test-"$BKFOLDER$ENTRACE2;
        #echo "$BKFOLDER$TGT2,$AGORA,444" >> $LPATH"/test-"$BKFOLDER$ENTRACE2;
    fi
else

    echo "else555-666";
    exit;

    printf "\n\n### $AGORA ###\n\n" >> $LPATH"/test-"$BKFOLDER$ENTRACE1;
    echo "$BKFOLDER$TGT1,$AGORA,555" >> $LPATH"/test-cron-"$BKFOLDER$ENTRACE1;

    printf "\n\n### $AGORA ###\n\n" >> $LPATH"/test-"$BKFOLDER$ENTRACE2;
    echo "$BKFOLDER$TGT2,$AGORA,666" >> $LPATH"/test-cron-"$BKFOLDER$ENTRACE2;
fi
