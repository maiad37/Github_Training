require 'mysql2'
require 'dotenv/load'
require_relative 'methods.rb'

client = Mysql2::Client.new(host: "db09.blockshopper.com", username: ENV['DB09_LGN'], password: ENV['DB09_PWD'],database: "applicant_tests")

#get_teacher(2, client)
#get_subject_teacher(client, 1)
#get_class_subjects(client, "Class A")
get_teachers_list_by_letter(client, "A")
client.close