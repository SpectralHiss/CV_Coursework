#!/bin/bash -ex

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


rsync -a $DIR/CW1 ITL:/homes/hef30/bitbucket

ssh -t -A ITL ssh -t -A itl115 /homes/hef30/bitbucket/CW1/build.sh


