#!/bin/bash -x
sourcepath="$(dirname "$1")" 

for f in "${sourcepath}"/*.mov "${sourcepath}"/*.MOV
do
  ./dvd.sh "$f"
done