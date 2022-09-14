require 'mysql2'
require 'dotenv/load'
require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'byebug'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

client = Mysql2::Client.new(host: "db09.blockshopper.com", username: ENV['DB09_LGN'], password: ENV['DB09_PWD'],database: "applicant_tests")

doc = Nokogiri::HTML(URI.open('https://www.cdc.gov/coronavirus/2019-ncov/covid-data/covidview/01152021/specimens-tested.html'))

doc.css('tbody tr').each do |table_data|
  table_data = table_data.text.split("\n")[1..-1]
  client.query("INSERT INTO covid_total_maia VALUES(#{table_data[0].to_i},#{table_data[1].delete(",").to_i},#{table_data[2].delete(",").to_f},#{table_data[3].delete(",").to_i},#{table_data[4].delete(",").to_f},#{table_data[5].delete(",").to_i},#{table_data[6].delete(",").to_f},#{table_data[7].delete(",").to_i},#{table_data[8].delete(",").to_f},#{table_data[9].delete(",").to_i},#{table_data[10].delete(",").to_f},#{table_data[11].delete(",").to_i},#{table_data[12].delete(",").to_f})")
end


