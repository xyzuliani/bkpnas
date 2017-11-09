#!/bin/bash
# ----------------------------------------------------------------------------------------
# bkpnas.sh - Script shell to manage backups (with Gdrive) in SEAGATE NAS and Cron Jobs
# Based on Gdrive: https://github.com/prasmussen/gdrive
# Autor: Marco Zuliani (xyzuliani@gmail.com)
# Date: Set/2017
# Version: 1.7.0
# Sample: $ ./bkpnas.sh Atual.log
# ----------------------------------------------------------------------------------------

ENTRACE=$1;

string=$(awk '/./{line=$0} END {print line;}' $ENTRACE);

AGORA=`date +%Y-%m-%d_%H_%M`;

RNUMPID=`pgrep gdrive`;

if test -n "$RNUMPID"
then
    echo "$RNUMPID,$AGORA" >> /shares/logs/cron.log;
    exit 0
fi

if [[ $string != *"finished"* ]]; then
    # /shares/./gdrive sync upload --keep-local --timeout 0 /shares/Teste 0B2748e8sENkZbVprLTNSVXU1anM > /shares/logs/Teste.log;

    # exemplo: nohup myInScript.sh >some.log 2>&1 </dev/null &

    printf "\n\n### $AGORA ###\n\n" >> /shares/logs/Atual.log

    /shares/./gdrive sync upload --keep-local --timeout 0 /shares/Atual 0B2748e8sENkZN3ZVTUFiaG1PaDA >> /shares/logs/Atual.log &
    APID=$!
    echo "Atual,$AGORA,$APID" >> /shares/logs/cron.log;
fi