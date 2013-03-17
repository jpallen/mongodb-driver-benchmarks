#!/bin/bash
values=( 500 600 700 800 900 1000 )
for i in "${values[@]}"
do
	echo "${i}0"
	coffee benchmark.coffee --spread=10000 --content-size=10 --mongoose --queries=${i}0 > results
	./plot.sh mongoose $i
done

