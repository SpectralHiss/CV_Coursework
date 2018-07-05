#!/bin/bash -ex

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

pushd $DIR
ant clean dist
hadoop jar $DIR/dist/CW1-Q1.jar Q1.CW1MessageLength /data/olympictweets2016rio out/tweet_lengths
hadoop jar $DIR/dist/CW1-Q2P1.jar Q2P1.CW1TweetsInHour /data/olympictweets2016rio out/tweets_in_hour
hadoop jar $DIR/dist/CW1-Q2P2.jar Q2P2.CW1TopTenHashTags /data/olympictweets2016rio out/hashtags_in_hour
hadoop jar $DIR/dist/CW1-Q3P1.jar Q3P1.CW1TopMentions /data/olympictweets2016rio out/top_mentions
hadoop jar $DIR/dist/CW1-Q3P2.jar Q3P2.CW1TopSports /data/twittercw-partC-input out/top_sports

popd
