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
  counter = 0

  if teacher_subject.count.zero?
    "Not found!"
  else
    puts "Subject: #{teacher_subject[0]['name']}\nTeachers: "
    while counter < teacher_subject.count
      puts "#{teacher_subject[counter]['first_name']} #{teacher_subject[counter]['middle_name']} #{teacher_subject[counter]['last_name']}"
      counter +=1
    end
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
  counter = 0

  if classes_subject.count.zero?
    puts "No results!"
  else
    puts "Class: #{classes_subject[0]["class"]}\nSubjects:\n"
    while counter < classes_subject.count
      puts "#{classes_subject[counter]["subject"]} - #{classes_subject[counter]["first_name"]} #{classes_subject[counter]["middle_name"][0]}. #{classes_subject[counter]["last_name"]}"
      counter+=1
    end
  end
end

#3
def get_teachers_list_by_letter(client, letter)
  ts =  "SELECT subjects_maia.name as subject, teachers_maia.first_name, teachers_maia.middle_name, teachers_maia.last_name
FROM teachers_classes_maia
JOIN teachers_maia ON teachers_maia.teacher_id = teachers_classes_maia.teacher_id
JOIN subjects_maia ON subjects_maia.id = teachers_maia.subject_id
WHERE teachers_maia.first_name LIKE '%#{letter}%' OR teachers_maia.last_name LIKE '%#{letter}%'"

  teachers_subjects = client.query(ts).to_a
  counter = 0

  if teachers_subjects.count.zero?
    puts "No results!"
  else
  while counter < teachers_subjects.count
    puts "#{teachers_subjects[counter]["first_name"][0]}. #{teachers_subjects[counter]["middle_name"][0]}. #{teachers_subjects[counter]["last_name"]} - #{teachers_subjects[counter]["subject"]}"
    counter +=1
  end
  end
end