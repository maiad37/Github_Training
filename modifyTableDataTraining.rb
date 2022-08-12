require 'mysql2';
client = Mysql2::Client.new(host: "localhost", username: "maia", password:"maia", database:"training")
data = client.query("Select id, lastname, email, email2 from people_maia").to_a

def editTableTraining(data, client)
  data.each do |hash|
    newLastNames = hash["lastname"].gsub("'", "").to_s + " - EDITED"
    client.query("Update people_maia set lastname = '#{newLastNames}', email = '#{hash["email"].downcase.gsub("'", "")}', email2 = '#{hash["email2"].downcase.gsub("'", "")}' where id = #{hash["id"]};")
  end
end

editTableTraining(data, client)

client.close
