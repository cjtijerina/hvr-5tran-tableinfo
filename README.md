#### hvr-5tran-tableinfo - Partition your HVR pipe-line by table activity

##### A:  Who and When:
Creator: ctijerina 
Creation time: 2018 changes thru 2022

#### B: Word Legend: 
1. CDC = change data capture - capturing inserts, updates and deletes
2. Client = the user of this script - can be you too.
3. Channel = this houses your pipe-line, it's like a project folder and your pipe-lines will be inside your Channel,
             every channel will produce 1 hvr.out file and this is the key file this script will run against.
             If you have many pipi-lines in 1 chanel, not to worry, this script will account for each pipe-line, remember
             all hvr channels will have 1 hvr.log file.             

#### C: This script runs on:
1. Linux
2. Mac Terminal
3. Windows(but must use WSL bash - it's a linux sub system on windows)

#### D: The goal:
1. Is to parse the hvr.out file for all CAPTURE activity for a given run time.
2. If no capture key word then integrate processed rows will be calculated

#### E: Steps to prep for this script:
NOTE: you don't have to have hvr/5tran installed to run this script, you can put your
      hvr.out file on any linux os along with this file and run this file.
1. The client will be asked to setup a Capture and allow it to run for 24+ hours (2 days)
   NOTE: If you're currently running hvr, even bettter, use this current hvr.log file.
   If you backup hvr.log and let's say you have 10 logs, Concat all 10 files into 1 big file,
   then use this 1 big file with this script. 

#### F: Where to put this script and how to run
1. Best place is the hvr_config/log/yourHubName
2. chmod +x hvrBusyTables_v13.2.bash
3. ./hvrBusyhvrBusyTables_v13.2.bash

#### G. End Results - output to console and to text files
1. Total # of Application Tables in your CDC Replication/PipeLine- 
2. Total # of Changed Rows - changed by Insert, Update or Delete - broTip: this is CDC
3. A list of all tables with the total amount of changed rows
4. Post programatically analyzing: Small - Medium - Busy groups based on calculation  sum/tableTotalchanged*100

#### H. BENEFITS - what to do with the output from this script
1. Determine how to parallelize your downstream pipe lines for better thru put, get to near real-time deivery of your data
    a. if you have a SLA of 1 min, and your data is breaking the SLA by 5 minutes, this tool will help you achieve near-real time deliver.
2. Use this data to proavtively determine capacity and when will it be time to add more capacity
    a. Every Insert means a new customer, which means more storage and os/db compute will be utilized
#####
