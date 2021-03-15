#!/bin/sh

while [ $# -gt 0 ]; do
    grep '\\newlabel{desc:[^.]\+\.[^.]\+\.'"$1"'[.=}]' *.aux
    shift
done
