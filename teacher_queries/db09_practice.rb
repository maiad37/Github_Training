require 'mysql2'
require 'dotenv/load'
require_relative 'methods.rb'
require 'digest'
require 'date'

client = Mysql2::Client.new(host: "db09.blockshopper.com", username: ENV['DB09_LGN'], password: ENV['DB09_PWD'],database: "applicant_tests")

#get_teacher(2, client)
#puts get_subject_teacher(client, 2)
#puts get_class_subjects(client, "Class B")
#puts get_teachers_list_by_letter(client, "a")
#puts set_md5(client)
#puts get_class_info(client, 1)
#puts get_teachers_by_year(client, 1970)
#puts random_date(1980, 2003)
#t = Time.now
#100.times do
 # random_last_names(client, 1)
#end
#puts Time.now - t
t = Time.now
random_people(client, 10000)
puts Time.now - t
#100.times do
 # random_first_names(client, 1)
#end
#puts Time.now - t

client.close