require 'mysql2'
require 'dotenv/load'

client = Mysql2::Client.new(host: "db09.blockshopper.com", username: ENV['DB09_LGN'], password: ENV['DB09_PWD'],database: "applicant_tests")

def clean_school_names (client)
  begin
    create = "CREATE TABLE hle_dev_test_maia LIKE hle_dev_test_candidates;"
    #insert = "INSERT INTO hle_dev_test_maia SELECT * FROM hle_dev_test_candidates;"
    #columns = "ALTER TABLE hle_dev_test_maia ADD COLUMN clean_name varchar(255) not null, ADD COLUMN sentence varchar(255) not null;"
    client.query(create)
  rescue
    puts "Table already exists"
  ensure
    clean = []
    candidate_offices = client.query('select candidate_office_name from hle_dev_test_maia;').to_a
    candidate_offices.each { |name|
      if name["candidate_office_name"].include?(",") == false && name["candidate_office_name"].include?("/") == false
        clean << name["candidate_office_name"].
                downcase.
                gsub("twp", "township").
                gsub("county county", "county").
                gsub("  ", " ").
                delete(".").
                gsub("twp", "township").
                gsub("hwy", "highway").
                gsub("highway highway", "highway").
                gsub("township twp", "township").
                gsub("township township", "township").
                gsub("city city", "city").
                gsub("'", "''").
                strip
        elsif name["candidate_office_name"].include?(",") == true && name["candidate_office_name"].include?("/") == false
          clean << name["candidate_office_name"].
              downcase.
              gsub("twp", "township").
              gsub("county county", "county").
              gsub("  ", " ").
              delete(".").
              gsub("twp", "township").
              gsub("hwy", "highway").
              gsub("highway highway", "highway").
              gsub("park park", "park").
              gsub("township twp", "township").
              gsub("township township", "township").
              gsub("city city", "city").
              gsub("'", "''").
              strip
      else
        before_slash = name["candidate_office_name"].scan(/([\s\S]*)\//).join("").downcase
        clean << name["candidate_office_name"].gsub(/([\s\S]*)\//, "#{before_slash}+").split("+").reverse.join(" ").
            gsub("/", " and ").
            gsub("Twp", "Township").
            gsub("County county", "County").
            gsub("  ", " ").
            delete(".").
            gsub("twp", "township").
            gsub("hwy", "highway").
            gsub("Highway highway", "Highway").
            gsub("Park park", "Park").
            gsub("Township twp", "Township").
            gsub("Township township", "Township").
            gsub("City city", "city").
            gsub("'", "''").
            strip
      end
    }
    clean_names = []
    clean.each do |row|
      if row.include?(",")
        after_comma = row.scan(/,([\s\S]*)/).join""
        clean_names << "#{row.gsub(/,([\s\S]*)/, " (#{after_comma.gsub(/\w+/) { |w| w.capitalize}.strip})")}"
      else
        clean_names << row
      end
    end
    count= 1
    clean_names.each do |val|
     client.query("UPDATE hle_dev_test_maia SET clean_name = '#{val}', sentence = 'The candidate is running for the #{val} office.' WHERE id = #{count};")
      count += 1
    end
    client.query("DELETE FROM hle_dev_test_maia WHERE candidate_office_name LIKE '%none%' OR candidate_office_name LIKE '%unknown%';")
  end
end
clean_school_names(client)