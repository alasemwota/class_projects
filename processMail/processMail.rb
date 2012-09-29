#!/usr/bin/env ruby

require 'rubygems'
require 'mail'
require 'csv'
require 'find'

class MailObject
	attr_accessor :message_id
	attr_accessor :body
	attr_accessor :to
	attr_accessor :from
	attr_accessor :file_name
	attr_accessor :subject
	attr_accessor :cc
	attr_accessor :date


	#checks to see if a mail object is valid. The file terminates otherwise.
	def validateMail()
		if @from.nil?
		    return false
		else
		    return true
		end
	end
	
	#constructor for the MailObject class
	def initialize(mail,file_name)
		@message_id = mail.message_id
		@body = mail.body.decoded
		@to = mail.to
		@from = mail.from
		@file_name = file_name
		@subject = mail.subject
		@cc = mail.cc
		@date = mail.date.to_s

	end
	
	#prints out all fields to the mail.csv file	
	def printFields()
		fields = [@file_name, @from, @to, @cc, @subject, @date, @message_id, @body]
		CSV.open("mail.csv","a") do |csv|
		csv << fields
		
		end					

	end

	#tokenizes the body of the mail and outputs it to tokens.csv
	def tokenize()
		body = @body.strip().downcase()
		body_tokens =  body.split(/[^a-z]+/)
		CSV.open("tokens.csv", "a") do |csv|
			body_tokens.each do |token|
			if token != ""
				string = [@message_id, token]
				csv << string
				end
			end
		end		 		
		CSV.open("unsorted_tokens.csv", "a") do |csv|
			body_tokens.each do |token|
			if token != ""
				string = [token]
				csv << string
				end
			end
		end	
	
	end

end

#checks to see if the file is a .txt
def validateFile(file)
	#puts(file)
	tokens = file.split(".")
	if tokens.last != "txt"
		#puts("rejected")
		return false
	else
		return true
	end
end

#counts how many individual tokens appear in tokens.csv
def countTokens()
       #first sort tokens.csv
       system("sort unsorted_tokens.csv > sorted_tokens.csv")
       count = 0
       currRow = ""
       row = ""
       		CSV.foreach("sorted_tokens.csv") do |row|
                        if count == 0
                                currRow = row
                                count += 1
                        elsif currRow[0] == row[0]
                                count += 1
                        else 
                                CSV.open("token_counts.csv", "a") do |csv|
                                        string = [currRow[0], count]
                                        csv << string
                                end
                                currRow = row
                                count = 1

                        end
                end
		CSV.open("token_counts.csv", "a") do |csv|
			string = [currRow[0], count]
			csv << string
		end
			
end

def getStateCount()
	states = ["alabama", "alaska", "arizona", "arkansas", "california", "colorado", "connecticut", "delaware", "florida", "georgia", "hawaii", "idaho", "illinois", "indiana", "iowa", "kansas", "kentucky", "louisiana", "maine", "maryland", "massachusetts", "michigan", "minnesota", "mississippi", "missouri", "montana", "nebraska", "nevada", "hampshire", "jersey", "mexico", "york", "carolina", "ohio", "oklahoma", "oregon", "pennsylvania", "rhode", "dakota", "tennessee", "texas", "utah", "vermont", "virginia", "washington", "wisconsin", "wyoming"]	

	states.each do|state|
		command = "grep -w " + state + " token_counts.csv >> state_counts.csv"
		system(command)
	end


end


if __FILE__ == $0
	Find.find(ARGV.fetch(0))  do |file|
		if validateFile(file) == true
			#file_name = ARGV.fetch(0) + "/" + file
			mail = Mail.read(file)
			mailObject = MailObject.new(mail,file)
			if mailObject.validateMail()
				mailObject.printFields()
				mailObject.tokenize()
			end
		end
	end
	countTokens()
	getStateCount()
end

		   		
