# hvr-5tran-tableinfo
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
