#!/bin/bash
# ----------------------------------------------------------------------------------------
# Test
# ----------------------------------------------------------------------------------------

# ddd=$(awk 'FNR==NR{a[$1];next}($1 in a){print}' tmpID2 tmpID1); // nao funciona

# ddd=$(awk -FS=" " 'NR==FNR {b[$0]; next} {for (x in b) if($0 ~ x) next;print $0}' tmpID2 tmpID1);
# echo $ddd;

onepid="Atual,2017-09-13_18_39,18043";

echo "${onepid##*,}"