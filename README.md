# BigDataDevKit

Big Data Development Kit (Hadoop / Spark / Zeppelin / IntelliJ) in Amazon AWS

Usage:

Launch an instance on Amazon WebServices

Specify in the initialization of the vm

```
#!/bin/bash
wget -O- http://bit.ly/1PjnNB3 |\
 PASSWORD="changeme"\
 TOKEN="duck-dns-token"\
 HOST="duckdnshost"\
 EMAIL="your@email"\
 bash
```
NOTE!
- You need to specify Amazon Linux 64 bit 
- You need at least an image small (2g) better 4g for running all the services
- You need at least 20 GB space
- Create a secondary block on sdb and the /app folder with all your data will be mounted there, thus preserved from termination
- change the password (change the string within the quotes with your password) to the one you want
- register an hostname in www.duckdns.org and get the token, and replace them in the TOKEN and HOST variables
- specify your email (user for let's encrypt service)
- if you have a backup of let's encrypt (for example in Dropbox) specify LETGZ="...." to the url of your backup
- before you  launch the instance add a rule to open the HTTPS ports to the world
 
# Spark /  Hadoop / Zeppelin devkit

Docker kit for Hadoop, Spark and Zeppelin 

Devenv with IntelliJ, SBT and Ammonite accessible via web

## Usage:

First, get a docker machine and configure your docker to access it.
Refer to docker documentation to learn how to do it.

The script `sh build.sh <password>` builds the enviroment.

Start it with `docker-compose up -d`.

That is all.

## What is in the kit

Access the shell with http://youserver:3000 and the desktop with http://yourserver:6080

In the kit there is Intellij free edition, a terminal with sbt and ammonite

Inside the kit you have also Zeppelin, internally accessible as

http://zeppelin.loc:8000, Hadoop accessible as hdfs://hadoop.loc:8020 and Spark on http://spark.loc

(to fix)
You can also ssh (without password) on  hadoop.loc, spark.loc and zeppelin.loc




