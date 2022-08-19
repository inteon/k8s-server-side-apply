#!/bin/bash

echo "Press any key to continue"
while [ true ] ; do
read -n 1
if [ $? = 0 ] ; then
break
else
echo "waiting for the keypress"
fi
done
