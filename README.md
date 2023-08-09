HVR-5Tran-TableInfo: Enhance Your HVR Pipeline Performance
Overview: The hvr-5tran-tableinfo tool empowers users to analyze and partition their HVR pipelines based on table activity, enabling optimal data throughput and efficient resource utilization.

Metadata:
Author: ctijerina
Date of Creation: 2018
Latest Update: 2022
Glossary:
CDC: Change Data Capture (capturing inserts, updates, and deletes).
Client: User of this script. This could be you!
Channel: Represents the HVR pipeline, analogous to a project folder. All channels generate a single hvr.out file, which this script parses.
Compute: Cumulative cost of resources like CPU, Memory, IO, and disk space. External factors like OS jobs, DB jobs, SQL, or third-party CDC tools can influence compute.
Platform Compatibility:
Linux
Mac Terminal
Windows (via WSL bash)
Objective:
Parse the hvr.out file for all CAPTURE activity for a designated runtime. If no capture keyword is found, integrated processed rows will be calculated.

Setup:
You don't need HVR/5Tran installed. Just place your hvr.out file and this script on any compatible system.
For optimal results, set up a Capture for 24+ hours. Existing HVR users can utilize their current hvr.log file. Multiple logs can be concatenated into a single file for this script.
Usage:
Download hvrBusyTables_v13.2.bash to a directory (e.g., /home/myName on server1).
Copy your hvr.out to the same directory.
Provide execution permissions: chmod +x hvrBusyTables_v13.2.bash.
Run the script: ./hvrBusyTables_v13.2.bash.
Output:
Total count of application tables in your CDC Replication Pipelines/Channels.
Cumulative changed rows segmented by Insert, Update, or Delete.
An analytic breakdown of tables based on the volume of changed rows.
Benefits:
Optimized Data Delivery: Improve the parallelization of your downstream pipelines for near real-time data delivery, especially beneficial if you're striving for stringent SLAs.
Capacity Forecasting: Leverage insights from the script to proactively determine capacity sizing, preparing for incremental data and its associated resource needs.
