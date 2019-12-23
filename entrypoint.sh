#!/bin/sh -l

echo "Hello $1"
echo "$(ls)"
echo "Hello again"
time=$(date)
echo ::set-output name=time::$time
