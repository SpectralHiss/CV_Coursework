#!/bin/bash -ex

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOP_DIR=$DIR/..
USERNAME="hef30"
ITLCONN="ITL" 

rsync -a $TOP_DIR/ ITL:/homes/$USERNAME/bitbucket/CW2

ssh -t -A $ITLCONN ssh -t -A itl305 /homes/$USERNAME/bitbucket/CW2/scripts/run.sh


