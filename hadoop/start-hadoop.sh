#!/bin/bash
echo "*** Starting SSHD"
sudo /etc/init.d/sshd start
echo "*** Starting DFS"
/app/hadoop/sbin/start-dfs.sh 
echo "*** Starting YARN"
/app/hadoop/sbin/start-yarn.sh
echo "*** Starting HistoryServer"
/app/hadoop/sbin/mr-jobhistory-daemon.sh start historyserver
