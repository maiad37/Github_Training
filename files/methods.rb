#EXAMPLE
def get_teacher(id, client)
  f = "select first_name, middle_name, last_name, birth_date from teachers_maia where teacher_id = #{id}"
  results = client.query(f).to_a
  if results.count.zero?
    puts "Teacher with ID #{id} wasn't found."
  else
    puts "Teacher #{results[0]['first_name']} #{results[0]['middle_name']} #{results[0]['last_name']} was born on #{(results[0]['birth_date']).strftime("%d %b %Y (%A)")}"
  end
end

#1)
def get_subject_teacher(client, subject_id)
  t = "select teachers_maia.first_name, teachers_maia.middle_name, teachers_maia.last_name, subjects_maia.name from teachers_maia JOIN subjects_maia ON teachers_maia.subject_id = subjects_maia.id WHERE subject_id = #{subject_id}"

  teacher_subject = client.query(t).to_a
  str = ""

  if teacher_subject.count.zero?
    str = "Not found!"
  else
    str += "Subject: #{teacher_subject[0]['name']}\nTeachers: "
    teacher_subject.each do |row|
      str += "\n#{row['first_name']} #{row['middle_name']} #{row['last_name']}"
    end
    str
    end
end

#2)
def get_class_subjects(client, className)
  classes =  "SELECT classes_maia.name as class, subjects_maia.name as subject, teachers_maia.first_name, teachers_maia.middle_name, teachers_maia.last_name
FROM teachers_classes_maia
JOIN teachers_maia ON teachers_maia.teacher_id = teachers_classes_maia.teacher_id
JOIN subjects_maia ON subjects_maia.id = teachers_maia.subject_id
JOIN classes_maia ON classes_maia.classes_id = teachers_classes_maia.class_id
WHERE classes_maia.name = '#{className}'"

  classes_subject = client.query(classes).to_a

  str=""
  if classes_subject.count.zero?
    str = "No results!"
  else
  str +="Class: #{classes_subject[0]["class"]}\nSubjects:"
  classes_subject.each do |row|
    str+= "\n#{row["subject"]} - #{row["first_name"]} #{row["middle_name"][0]}. #{row["last_name"]}"
  end
    str
  end
end

#3
def get_teachers_list_by_letter(client, letter)
  ts =  "SELECT subjects_maia.name as subject, teachers_maia.first_name, teachers_maia.middle_name, teachers_maia.last_name
FROM teachers_classes_maia
JOIN teachers_maia ON teachers_maia.teacher_id = teachers_classes_maia.teacher_id
JOIN subjects_maia ON subjects_maia.id = teachers_maia.subject_id
WHERE teachers_maia.first_name LIKE '%#{letter}%' OR teachers_maia.last_name LIKE '%#{letter}%'
GROUP BY teachers_maia.first_name"

  teachers_subjects = client.query(ts).to_a
  str = ""

  if teachers_subjects.count.zero?
    str = "No results!"
  else
  teachers_subjects.each do |row|
    str += "#{row["first_name"][0]}. #{row["middle_name"][0]}. #{row["last_name"]} - #{row["subject"]}\n"
  end
  end
  str
end

#4
def set_md5(client)
  r = "SELECT concat(first_name, middle_name, last_name, birth_date, current_age) AS con, teacher_id FROM teachers_maia"

  teacher_md5 = client.query(r).to_a

  teacher_md5.each do |row|
    client.query("UPDATE teachers_maia SET md5 = \"#{Digest::MD5.hexdigest row["con"]}\" WHERE teacher_id = #{row["teacher_id"]}")
  end
  puts "success"
end

#5
def get_class_info(client, id)
    r = "SELECT classes_maia.name AS class, teachers_maia.first_name, teachers_maia.middle_name, teachers_maia.last_name FROM classes_maia JOIN teachers_maia ON classes_maia.responsible_teacher_id = teachers_maia.teacher_id WHERE classes_maia.classes_id = #{id};"
    class_info = client.query(r).to_a
    str = ""

    if class_info.count.zero?
      "No results"
    else
      str +="Class name: #{class_info[0]["class"]} \nResponsible teacher: #{class_info[0]["first_name"]} #{class_info[0]["middle_name"]} #{class_info[0]["last_name"]} \nInvolved teachers: "
      class_info.each do |row|
        str += "\n- #{row["first_name"]}"
      end
      str
    end
end

#6
def get_teachers_by_year(client, year)
  r = "SELECT first_name, middle_name, last_name FROM teachers_maia WHERE YEAR(birth_date) = #{year}"
  teachers_years = client.query(r).to_a
  str = ""
  if teachers_years.count.zero?
    "No results"
  else
    str += "Teachers born in #{year}: "
    teachers_years.each do |row|
      str += "\n#{row["first_name"]} #{row["middle_name"]} #{row["last_name"]}"
    end
    str
  end
end

#7
def random_date(start_year, finish_year, n)
  counter = 0
  arr = []
  while counter < n
    month = rand(1..12)
    day = rand(1..28)
    year = rand(start_year..finish_year)
    arr << Date.new(year, month, day)
    counter += 1
  end
  arr.join(",")
end

#8
def random_last_names(client, n)
  r = "SELECT last_name FROM last_names ORDER BY rand() LIMIT #{n}"
  rand_last_names = client.query(r).to_a
  arr = []
  rand_last_names.each do |name|
    arr << "#{name["last_name"]}"
  end
  arr.join(",")
end

#FASTER WAY USING INSTANCE VARIABLES!
def last_names(n, client)
  l = "SELECT last_name FROM last_names"
  @results = @results ? @results : client.query(l).to_a
  res = @results.sample(n).map{|r| "#{r['last_name']}"}.join(', ')
  if @results.count == 0
    "Nothing found"
  else
    "#{res}"
  end
end
#9
def random_first_names(client, n)
  r = "SELECT names FROM female_names UNION ALL
SELECT FirstName AS names FROM male_names ORDER BY rand() LIMIT #{n}; "
  arr = []
  rand_first_names = client.query(r).to_a
  rand_first_names.each do |name|
    arr << "#{name["names"]}"
  end
  arr.join(",")
end

#10
def random_people(client, n)
  arr = (0..n-1)
  date = random_date(1910, 2022, n).split(",").to_a
  name = random_first_names(client, n).split(",").to_a
  last = random_last_names(client, n).split(",").to_a
  arr.each do |x|
    x = arr.find_index(x)
    client.query("INSERT INTO random_people_maia (first_name, last_name, birth_date) VALUES('#{name[x]}', '#{last[x]}', '#{date[x]}')")
  end
end