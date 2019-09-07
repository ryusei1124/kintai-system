User.create!(name:  "管理者",
             email: "email@sample.com",
             password:              "password",
             password_confirmation: "password",
             affiliation: "管理",
             employee_number: "111",
             uid: "aaa",
             admin: true)

User.create!(name:  "上長A",
             email: "email0@sample.com",
             password:              "password",
             password_confirmation: "password",
             affiliation: "経営",
             employee_number: "222",
             uid: "bbb",
             superior: true)             

59.times do |n|
  name  = Faker::Name.name
  email = "email#{n+1}@sample.com"
  password = "password"
  affiliation = "フリーランス部"
  employee_number = "1#{n+1}"
  uid = "abc"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               affiliation: affiliation,
               employee_number: employee_number,
               uid: uid)
end