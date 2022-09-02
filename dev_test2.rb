require 'mysql2'
require 'dotenv/load'

client = Mysql2::Client.new(host: "db09.blockshopper.com", username: ENV['DB09_LGN'], password: ENV['DB09_PWD'],database: "applicant_tests")

def clean_school_names (client)
  begin
    create = "CREATE TABLE hle_dev_test_maia LIKE hle_dev_test_candidates;"
    insert = "INSERT INTO hle_dev_test_maia SELECT * FROM hle_dev_test_candidates;"
    columns = "ALTER TABLE hle_dev_test_maia ADD COLUMN clean_name varchar(255) not null, ADD COLUMN sentence varchar(255) not null;"
    client.query(create, insert, columns)
  rescue
    puts "Table already exists"
  ensure
    arr = []
    candidate_offices = client.query("SELECT candidate_office_name FROM hle_dev_test_maia").to_a
    candidate_offices.each { |name|
      before_slash = name["candidate_office_name"].scan(/([\s\S]*)\//).join("").downcase
      arr << name["candidate_office_name"].gsub(/([\s\S]*)\//, "#{before_slash}+").split("+").reverse.join(" ").
          gsub("/", " and ").
          gsub("Twp", "Township").
          gsub("County county", "county").
          gsub("  ", " ").delete(".").
          gsub("twp", "township").
          gsub("hwy", "highway").
          gsub("Highway highway", "Highway").
          gsub("Township twp", "Township").
          gsub("Township township", "Township").
          gsub("City city", "City").
          gsub("'", "''").
          strip
    }
    clean_names = []
    arr.each do |row|
      after_comma = row.scan(/,([\s\S]*)/).join""
      clean_names << row.gsub(/,([\s\S]*)/, " (#{after_comma.gsub(/\w+/) { |w| w.capitalize}.strip})")
    end

    count= 1
    clean_names.each do |val|
      client.query("UPDATE hle_dev_test_maia SET clean_name = '#{val}', sentence = 'The candidate is running for the #{val} office.' WHERE ID = #{count};")
      count += 1
   end
  end
end

clean_school_names(client)