This program reads in emails in the csv format and prints out 6 different output files:
1) Mail.csv is the file where each field of every email read by the program is printed out. The fields are defined
   as per the Ruby Mail documentation.

2) The tokens.csv file has the format: message_id, token where token is every individual group of alphanumeric 
   character(s) in the email file and message_id is the id ascribed to each mail in the file.

3) The unsorted_tokens.csv file outputs the tokens.csv file with the message_id stripped off.

4) The sorted_tokens.csv file sorts the unsorted_tokens.csv file.

5) Token_counts.csv file counts the total number of times a token appears in the collective set of emails.

6) State_counts.csv file counts the number of times the 48 characters, loosely representating states in the US, 
   appear in the email collection. 
