#!/usr/bin/env bash

subdirs=$(find mstep_all -mindepth 1 -maxdepth 1 -type d)

for subdir in $subdirs
do
subdir_name=$(basename $subdir)
echo "removing ./${subdir_name}"
rm -rf ./$subdir_name
done

rm -rf mstep_out*
