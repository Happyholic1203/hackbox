#!/bin/bash

version=0.5.1

echo "Start time: $(date "+%Y-%m-%d %H:%M:%S")"
docker build -t happyholic1203/hackbox:$version .
echo "Finish time: $(date "+%Y-%m-%d %H:%M:%S")"
