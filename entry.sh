#!/bin/bash

echo launching xdummy

X -config dummy-1920x1080.conf </dev/null &>/dev/null &

echo launching electron application

DISPLAY=:0 electron main.js