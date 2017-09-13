#!/bin/bash

./formalog
rm /tmp/wtf.txt
echo "VVVVVVVVVVVVVVVVVVVVVVVVVVVV"
./run
cat /tmp/wtf.txt
