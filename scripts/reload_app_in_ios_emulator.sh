#!/bin/sh
for f in /tmp/bp_*; do
   signal=$1
   kill -s $signal $(cat $f);
done
