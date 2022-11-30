#!/bin/bash
for directory in * ; do
    echo "$directory"
    cd $directory
    git add .gitlab-ci.yml
    git commit -m "Some commit"
    git push
    # git checkout develop
    # git pull
    cd ..
done