# Self-made LogCollect including Sucessful Jobs
For the investigation of jobs that ran successfully but inefficient, it is important to have a look at the caching proxy log, monit-opensearch, and the job logs.
In /eos, however, only the failed job logs are stored.
To get access to successful logs, we need to get them from the site directly BEFORE LogCollect jobs are removing them.
These scripts do the job.

In our case, we use the scripts to investigate jobs that run inefficiently on our opportunistic HPC resources.
Those, we identify with our meta-monitoring tool [HappyFace4](https://hf.etp.kit.edu/) and then collect the available logs from our Tier-1 (GridKa).

**NOTE: Currently, this is hardcoded for GridKa**

## collect_logs.sh
- This script copies all selected logs from GridKa.
- It is useful to select a certain campaign (type) in advanced as it can take quiet some time and space to get all logs. For this, we can have a look in the monit-opensearch for a job that was inefficient. Starting the script without the <selection> parameter selects everything. This also can be used to get an overview, since all directories that will be copied are listed
- **NOTE: it is not necessary to specify a "*" for wildcards, like pdmvsrv_, because `grep -F` is used for the selection!**
- Since the script collects all logs, we also get all failed logs and can then select certain errors in the next step with the select_and_cleanup.sh script.

`Usage: ./collect_logs.sh year(20XX) month(no prefixed 0) day(no prefixed 0) selection-wildcard(no "*" necessary)`

`Example: ./collect_logs.sh 2024 1 24 pdmvserv_`

## select_and_cleanup.sh
- This script let's us select certain jobs that for example were running at HoreKa, which is preatty helpful, since we get all jobs of all sites (and subsites) in the same campaign directories.
- The script simply uses `zgrep` to look for a certain specifier and removes all .tar.gz files that do not contain it. This specifier can be generic. It just should uniquely identify the logs you are looking for.
- We can also use this mechanism to select certain errors via grep'ing for the error message.
- **NOTE: In the last step, the script automatically removes empty directories. Be very careful that the directory you have selected is the correct one!!**

`Usage: ./select_and_cleanup.sh directory specifier`

`Example: ./select_and_cleanup.sh 2024124 localdomain` # for selecting HoreKa jobs, as we grep here for the hostname prefix that uniquely identifies HoreKa jobs - as an Example. We could also select for error codes or else!

# Todo:
- generalize the scripts for other sites
