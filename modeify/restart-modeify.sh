#!/usr/bin/env bash
#
kill -9 `ps ax | grep node | grep -v grep | awk '{print $1}' | tr '\n' ' '`
sleep 3
npm start
tail -f server.log
