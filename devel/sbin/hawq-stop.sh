#!/bin/bash
set -x
hdfs dfs -rm -r /hawq_default
rm -rf /home/oushu/hawq-data-directory/*
ps -ef | grep postgres | grep -v grep | awk '{print $2}'| xargs kill -9
ps -ef | grep magma | grep -v grep | awk '{print $2}'| xargs kill -9
