#!/bin/sh
gnuplot << EOF
clear
reset
set key off
set border 3
set auto
 
# Make some suitable labels.
set title "$1 - $2 requests per second"
set xlabel "Response Time (milliseconds)"
set ylabel "Count"
 
set terminal png enhanced font arial 14 size 800, 600
ft="png"
# Set the output-file name.
set output "$1-$2-per-second.".ft
 
set style histogram clustered gap 1
set style fill solid border -1
 
binwidth=5
set boxwidth binwidth
bin(x,width)=width*floor(x/width) + binwidth/2.0
 
plot 'results' using (bin(\$1,binwidth)):(1.0) smooth freq with boxes
EOF
