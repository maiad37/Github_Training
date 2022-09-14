def clean_school_names (client)
  begin
    client.query("CREATE TABLE montana_public_district_report_card__uniq_dist_maia(id int not null auto_increment, name varchar(255) not null, clean_name varchar(255) not null, address varchar(255) not null, city varchar(255) not null, state varchar(2) not null, zip int not null)")
    rescue
    puts "error has ocurred"
    else
    puts "no error"
    ensure
      r = "select school_name, address, city, state, zip from montana_public_district_report_card group by school_name, address, city, state, zip;"
      school_info = client.query(r).to_a
      clean_names = school_info.collect{ |school| school["school_name"].gsub("Elem", "Elementary School").gsub("H S", "High School").gsub("K-12","Public School").gsub("K-12 Schools", "Public School").gsub("Schools", "") + " District"}
      x = 0
      school_info.each do |school|
        client.query("INSERT INTO montana_public_district_report_card__uniq_dist_maia(name, clean_name, address, city, state, zip) VALUES('#{school["school_name"]}','#{clean_names[x]}','#{school["address"]}','#{school["city"]}','#{school["state"]}','#{school["zip"]}');")
        x+=1
      end
  end
end
