# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#





=begin
# 用于批量录入数据库测试数据
99.times do |n|
  n += 27
  s = n%2
  nick_name = Faker::Name.name
  username = Faker::Name.name
  email = "example-#{n+1}@giabbs.com"
  password = "password"
  phone_num = "132556677#{n}"
  sex = "#{s}"
  User.create!(
    nick_name: nick_name,
    username: username,
    email: email,
    password: password,
    password_confirmation: password,
    phone_num: phone_num,
    sex: sex
  )
end
=end

users = User.order(:id).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

