#!/bin/bash
# bash command-line arguments are accessible as $0 (the bash script), $1, etc.
echo "Running" $0 "on" $1
echo "Processing files"


#Remove old csv files
rm -f *.csv 

#Put headers into new csv files
echo "file_name,from,to,cc,subject,date,message_id,body">>mail.csv

echo "message_id,token">>tokens.csv

echo "token,count">>token_counts.csv

echo "token,count">>state_counts.csv

#Processing mail.csv and tokens.csv
./processMail.rb $1

#Processing token_counts.csv and state_counts.csv

exit 0

