#!/bin/bash

function provisionLength() { 
  while [[ true ]]; do
  done
}

hei &
hei_pid=$!

while [[ $j -ne 10 ]]; do sleep 1; let j=$j+1; done

kill $hei_pid >/dev/null 2>&1

echo "døde etter 10sek"
