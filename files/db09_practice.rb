require 'mysql2'
require 'dotenv/load'
require 'digest'
require 'date'
require_relative 'methods.rb'
require_relative 'cleaning.rb'

client = Mysql2::Client.new(host: "db09.blockshopper.com", username: ENV['DB09_LGN'], password: ENV['DB09_PWD'],database: "applicant_tests")

t = Time.now
#random_people(client, 10000)
clean_school_names (client)
puts Time.now - t

client.close