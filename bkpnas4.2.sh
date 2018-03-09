#!/bin/bash
# ----------------------------------------------------------------------------------------
# bkpnas4.sh - Script shell to manage backups (with Rclone) in SEAGATE NAS and Cron Jobs
# Based: Rclone - https://rclone.org
# Autor: Marco Zuliani (xyzuliani@gmail.com)
# Date: Nov/2017
# Version: 4.2.0
# Sample: $ ./bkpnas4.2.sh VOLUME_1.log VOLUME_2.log BACKUPS-SYNC-NAS-DAILY
# OR
# Sample: $ ./bkpnas4.2.sh VOLUME_1.log VOLUME_2.log BACKUPS-AGENDADOS-BY-NAS BKP_
# ----------------------------------------------------------------------------------------

ENTRACE1=$1;
ENTRACE2=$2;
DESTPATH=$3;
BKFOLDER=$4;

TGT1=${ENTRACE1%.*};
TGT2=${ENTRACE2%.*};

DPATH="/root/logs";

if [ ! -w $DPATH"/"$BKFOLDER$ENTRACE1 ]
then
    touch $DPATH"/"$BKFOLDER$ENTRACE1;
fi

if [ ! -w $DPATH"/"$BKFOLDER$ENTRACE2 ]
then
    touch $DPATH"/"$BKFOLDER$ENTRACE2;
fi

if [ ! -w $DPATH"/cron-"$BKFOLDER$ENTRACE1 ]
then
    touch $DPATH"/cron-"$BKFOLDER$ENTRACE1;
fi
                            
if [ ! -w $DPATH"/cron-"$BKFOLDER$ENTRACE2 ]
then
    touch $DPATH"/cron-"$BKFOLDER$ENTRACE2;
fi

if [ ! -w $DPATH"/"$BKFOLDER$ENTRACE1 ]
then
    echo "File 1 does not exist or not writable";
    exit 0
fi

if [ ! -w $DPATH"/"$BKFOLDER$ENTRACE2 ]
then
    echo "File 2 does not exist or not writable";
    exit 0
fi

if [ ! -w $DPATH"/cron-"$BKFOLDER$ENTRACE1 ]
then
    echo "File 3 does not exist or not writable";
    exit 0
fi

if [ ! -w $DPATH"/cron-"$BKFOLDER$ENTRACE2 ]
then
    echo "File 4 does not exist or not writable";
    exit 0
fi

AGORA=`date +%Y-%m-%d_%H_%M`;

RNUMPID=`pgrep rclone | sed ':a;N;$!ba;s/\n/,/g'`

onepid=$(awk '/./{line=$0} END {print line;}' $DPATH"/cron-"$BKFOLDER$ENTRACE1);
twopid=$(awk '/./{line=$0} END {print line;}' $DPATH"/cron-"$BKFOLDER$ENTRACE2);
                            
GDRIVE="backup-nas";        
                            
source1="/shares/$TGT1";    
destiny1="/$DESTPATH/$BKFOLDER$TGT1";
                            
source2="/shares/$TGT2";    
destiny2="/$DESTPATH/$BKFOLDER$TGT2";
                            
if test -n "$RNUMPID"       
then                        
                            
    PID1="${onepid##*,}";   
    PID2="${twopid##*,}";   
                            
    if [[ $RNUMPID == *"$PID1"* ]]; then
                            
        echo "$TGT1,$AGORA,$PID1" >> $DPATH"/cron-"$BKFOLDER$ENTRACE1;
    else                    
                            
        printf "\n\n### $AGORA ###\n\n" >> $DPATH"/"$BKFOLDER$ENTRACE1;
                            
        #setsid /root/./rclone -v sync /shares/VOLUME_1 backup-nas:/BACKUPS-SYNC-NAS-DAILY/VOLUME_1 --log-file /root/logs/VOLUME_1.log &>/dev/null
        setsid /root/./rclone -v sync $source1 $GDRIVE":"$destiny1 --log-file $DPATH"/"$BKFOLDER$ENTRACE1 &
        AID1=$!             
                            
        echo "$TGT1,$AGORA,$AID1" >> $DPATH"/cron-"$BKFOLDER$ENTRACE1;
    fi                      
                            
    if [[ $RNUMPID == *"$PID2"* ]]; then
                            
        echo "$TGT2,$AGORA,$PID2" >> $DPATH"/cron-"$BKFOLDER$ENTRACE2;
    else                    
                            
        printf "\n\n### $AGORA ###\n\n" >> $DPATH"/"$BKFOLDER$ENTRACE2;
                            
        setsid /root/./rclone -v sync $source2 $GDRIVE":"$destiny2 --log-file $DPATH"/"$BKFOLDER$ENTRACE2 &
        AID2=$!             
                            
        echo "$TGT2,$AGORA,$AID2" >> $DPATH"/cron-"$BKFOLDER$ENTRACE2;
    fi                      
                            
else                        
                            
    printf "\n\n### $AGORA ###\n\n" >> $DPATH"/"$BKFOLDER$ENTRACE1;
                            
    setsid /root/./rclone -v sync $source1 $GDRIVE":"$destiny1 --log-file $DPATH"/"$BKFOLDER$ENTRACE1 &
    AID1=$!                 
                            
    echo "$TGT1,$AGORA,$AID1" >> $DPATH"/cron-"$BKFOLDER$ENTRACE1;
                            
                            
    printf "\n\n### $AGORA ###\n\n" >> $DPATH"/"$BKFOLDER$ENTRACE2;
                            
    setsid /root/./rclone -v sync $source2 $GDRIVE":"$destiny2 --log-file $DPATH"/"$BKFOLDER$ENTRACE2 &
    AID2=$!                 
                            
    echo "$TGT2,$AGORA,$AID2" >> $DPATH"/cron-"$BKFOLDER$ENTRACE2;
fi
