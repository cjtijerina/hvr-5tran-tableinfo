#!/bin/bash

#######################################################################################
## Creator: ctijerina 
## Creation time: 2018 changes thru 2022
## Legend: CDC = change data capture - capturing inserts, updates and deletes
##         Client: the user of this script - can be you too.
## This script runs on: Linux, Mac Terminal, Windows(but must use WSL bash - it's a linux sub system on windows)
##
## The goal is to parse the hvr.out file for all CAPTURE activity for a given run time.
## If no capture key word then integrate processed rows will be calculated
## The client will be asked to setup a Capture and allow it to run for 24+ hours (2 days)
## The client will send HVR the hvr.out file and run this script against the hvr.out file
#### A. Where to put this script and how to run
# 1. Best place is the hvr_config/log/yourHubName
# 2. chmod +x the file
# 3. ./hvrBusyTables_v##.bash - current is v13.2
#### B. End Results
# 1. Total # of Application Tables in your CDC Replication/PipeLine- 
# 2. Total # of Changed Rows - changed by Insert, Update or Delete - broTip: this is CDC
# 3. A list of all tables with the total amount of changed rows
# 4. Post programatically analyzing: Small - Medium - Busy groups based on calculation  sum/tableTotalchanged*100
#### C.BENEFITS - what to do with the output from this script
# 1. Determine how to break up parallize your downstream pipe lines for better thru put
# 2. Use this data to proavtively determine capacity and when will it be time to add more capacity
#    a. Every Insert means a new customer, which means more storage and os/db compute will be utilized
######################################################################################

#INPUTFILE=hvr.out
INPUTFILE=$1

##Obtaining your channel name via a prompt for the user
clear
read -p "Enter the Channel Name: " channelname
echo    "-------------------------------------------------"

##1
##1st grep for all captured lines for a certain channel - parsing raw data
grep ''$channelname'-cap.*Captured\|Captured.*'$channelname'-cap' $INPUTFILE > hvrProcessedRowsA1a
grep ''$channelname'-integ.*Integrated\|Integrated.'$channelname'-integ' $INPUTFILE > hvrProcessedRowsA1b

if [ -s hvrProcessedRowsA1a ]; then
	mv hvrProcessedRowsA1a hvrProcessedRowsA
	grep ''$channelname'-cap.*Captured\|Captured.*'$channelname'-cap' $INPUTFILE > hvrProcessedRowsA1a
	else
	mv hvrProcessedRowsA1b hvrProcessedRowsA
fi


##2
##1st grep get Table names - 2nd grep only list out table names without single quotes - then merge columns
grep -i '''' hvrProcessedRowsA > hvrProcessedRowsBt
grep -oP "(?<=').*?(?=')" hvrProcessedRowsBt > hvrProcessedRowsCt
paste hvrProcessedRowsCt hvrProcessedRowsBt | awk '{print $2,$3,$1, $4, $5, $6}' > hvrProcessedRowsDt
#Capturing Total Changed Rows
paste hvrProcessedRowsCt hvrProcessedRowsBt | awk '{print $5}' > hvrTotalCapturedRows
varTotalCapturedRows=`awk -F":" '{x += $1} END {print "Total Changed Rows: "x}' hvrTotalCapturedRows`
varx=`awk -F":" '{x += $1} END {print x}' hvrTotalCapturedRows`

##3
##Sorting and placing all tables in alpha order
cat hvrProcessedRowsDt | awk '{print $1, $3, $5, $6}' | sort -k 2 > hvrProcessedRowsEt
##Obtain time frame of collection based on dates
var1b=`awk '{print $1}' hvrProcessedRowsEt | head -1`  ##Beginning Time
var2e=`tail -1 hvrProcessedRowsEt | awk '{print $1}'`  ##End Time

##4 Printing parsed info into a file that will have columns and will be tab seperated
echo    "-------------------------------------------------" > hvrProcessedRowsFt
echo -e "Channel Name:"'\t\t' $channelname>> hvrProcessedRowsFt 
echo -e "Start Time:"'\t\t' $var1b>> hvrProcessedRowsFt
echo -e "End Time:"'\t\t' $var2e>> hvrProcessedRowsFt
echo -e "-------------------------------------------------" >> hvrProcessedRowsFt
echo "TableName ChangedRows" | awk '{printf("%-35s%-35s\n",$1,$2) }'>> hvrProcessedRowsFt
awk '{arr[$2]+=$3} END {for (i in arr) {print i,arr[i]}}' hvrProcessedRowsEt | sort -k 2n | awk '{printf("%-35s%-35s\n",$1,$2) }' > hvrGroupedTables
awk '{arr[$2]+=$3} END {for (i in arr) {print i,arr[i]}}' hvrProcessedRowsEt | sort -k 2n | awk '{printf("%-35s%-35s\n",$1,$2) }' >> hvrProcessedRowsFt
vartotaltables=`wc -l hvrGroupedTables | awk '{print $1}'`
echo -e "+++++" >> hvrProcessedRowsFt
echo -e "Total Tables CAPTURE processed:"'\t'$vartotaltables >> hvrProcessedRowsFt
echo -e "$varTotalCapturedRows" >> hvrProcessedRowsFt
echo    "-------------------------------------------------" >> hvrProcessedRowsFt

##4b Grouping by % usage of total captured rows processed
awk '{arr[$1]=$2/'$varx'} END {for (i in arr) {print (i, arr[i]*100)}}' hvrGroupedTables | sort -k 2n | awk '{printf("%35s%15s\n",$1, $2) }' > outoutAout


awk ' $2 <= 10.00 ' outoutAout > group1b
awk ' $2 > 10.00 && $2 < 75.00 ' outoutAout > group2b
awk ' $2 > 75.00 && $2 < 100.00 ' outoutAout > group3b

##5
## Add suggestions to client based on findings.  WIP
awk ' $2 <= 100000 ' hvrGroupedTables > group1
awk ' $2 > 100000 && $2 < 1000000 ' hvrGroupedTables > group2
awk ' $2 > 1000000 && $2 < 10000000 ' hvrGroupedTables > group3
awk ' $2 > 10000000 && $2 < 100000000 ' hvrGroupedTables > group4
awk ' $2 > 100000000 && $2 < 100000000000 ' hvrGroupedTables > group5
#--
if [[ -s group1b ]]; then
	echo "LIGHT-GROUP" >> hvrProcessedRowsFt
	echo "TableName Total%OfProcRows" | awk '{printf("%-35s%-35s\n",$1,$2) }'>> hvrProcessedRowsFt
	cat group1b | awk '{printf("%-35s%-35s\n",$1,$2) }' >> hvrProcessedRowsFt
	echo "-------------------------------------------------" >> hvrProcessedRowsFt
fi
#--
if [[ -s group2b ]]; then
	echo "MEDIUM-GROUP" >> hvrProcessedRowsFt
	echo "TableName Total%OfProcRows" | awk '{printf("%-35s%-35s\n",$1,$2) }'>> hvrProcessedRowsFt
	cat group2b | awk '{printf("%-35s%-35s\n",$1,$2) }' >> hvrProcessedRowsFt
	echo "-------------------------------------------------" >> hvrProcessedRowsFt
fi
#--
if [[ -s group3b ]]; then
	echo "HEAVY-GROUP" >> hvrProcessedRowsFt
	echo "TableName Total%OfProcRows" | awk '{printf("%-35s%-35s\n",$1,$2) }'>> hvrProcessedRowsFt
	cat group3b | awk '{printf("%-35s%-35s\n",$1,$2) }' >> hvrProcessedRowsFt
	echo "-------------------------------------------------" >> hvrProcessedRowsFt
fi
#--
if [[ -s group4b ]]; then
	echo "GROUP_4" >> hvrProcessedRowsFt
	echo "TableName Total%OfProcRows" | awk '{printf("%-35s%-35s\n",$1,$2) }'>> hvrProcessedRowsFt
	cat group4b | awk '{printf("%-35s%-35s\n",$1,$2) }' >> hvrProcessedRowsFt
	echo "-------------------------------------------------" >> hvrProcessedRowsFt
fi


##6
## Printing file and copying file to final version with channel name prefixed
cat hvrProcessedRowsFt
cp hvrProcessedRowsFt "$channelname"_hvrProcessedRows

##7
## Cleanup
rm hvrProcessedRowsA 2> /dev/null
rm hvrProcessedRowsA1a 2> /dev/null
rm hvrProcessedRowsA1b 2> /dev/null
rm hvrProcessedRowsBt 2> /dev/null
rm hvrProcessedRowsCt 2> /dev/null
rm hvrProcessedRowsDt 2> /dev/null
rm hvrProcessedRowsEt 2> /dev/null
rm group* 2> /dev/null
rm outoutAout 2> /dev/null
rm hvrGroupedTables 2> /dev/null
rm hvrTotalCapturedRows 2> /dev/null 
rm hvrProcessedRowsFt 2> /dev/null
