#! /bin/bash

set -o xtrace

MEASUREMENTS=10
ITERATIONS=10
INITIAL_SIZE=16
INITIAL_THREADS=1

NAMES=('mandelbrot_seq' 'mandelbrot_pth' 'mandelbrot_omp')

make
mkdir results

for NAME in ${NAMES[@]}; do
    mkdir results/$NAME
    if [ $NAME = 'mandelbrot_seq' ] 
    then
        end=1
    else 
        end=6
    fi
    for ((t=1; t<=$end; t++)); do
        SIZE=$INITIAL_SIZE
        for ((i=1; i<=$ITERATIONS; i++)); do
            echo "Info $THREADS $SIZE $MEASUREMENTS" >> full.log 2>&1
            echo "Info $THREADS $SIZE $MEASUREMENTS" >> seahorse.log 2>&1
            echo "Info $THREADS $SIZE $MEASUREMENTS" >> elephant.log 2>&1
            echo "Info $THREADS $SIZE $MEASUREMENTS" >> triple_spiral.log 2>&1
            for ((j=1; j<=$MEASUREMENTS; j++)); do
                ./$NAME -2.5 1.5 -2.0 2.0 $SIZE $THREADS >> full.log 2>&1
                ./$NAME -0.8 -0.7 0.05 0.15 $SIZE $THREADS >> seahorse.log 2>&1
                ./$NAME 0.175 0.375 -0.1 0.1 $SIZE $THREADS >> elephant.log 2>&1
                ./$NAME -0.188 -0.012 0.554 0.754 $SIZE $THREADS >> triple_spiral.log 2>&1
            done
            SIZE=$(($SIZE * 2))
        done
        THREADS=$(($THREADS * 2))
    done

    SIZE=$INITIAL_SIZE
    THREADS=$INITIAL_THREADS
    mv *.log results/$NAME
    rm output.ppm
done
