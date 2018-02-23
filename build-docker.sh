#!/bin/bash
docker system prune -a -f
docker-compose up --build | tee modeify-docker-`date +"%F-%T"`.log
