#!/bin/bash

script="java_run_fordate"

function printUsage {
    echo "USAGE: "
    echo "  $script jarfile [DATE_FROM] [DATE_UNTIL]  Execute job for a date range (inclusive)"
    echo "  $script jarfile [ETT_DATE]                Execute job for a specific day"
    echo "  $script jarfile                           Execute job for last day only"
    exit $1
}

function runJob {
    java -jar $jar $1
}

#Jar file to run
jar=$1

if [ $# -eq 0 ]; then
    printUsage -1
fi

if [ -n "$2" ]; then
    startdate=$(date -d "$2" +%Y%m%d) || printUsage -1
else
    startdate=$(date -d "- 1 day" +%Y%m%d)
fi

if [ -n "$3" ]; then
    enddate=$(date -d "$3" +%Y%m%d) || printUsage -1
else
    runJob $startdate
    exit 0
fi

d="$startdate"
while [ "$(date -d "$d" +%Y%m%d)" -le "$(date -d "$enddate" +%Y%m%d)" ]; do
    runJob $d
    d=$(date -d "$d + 1 day" +%Y%m%d)
done
