require 'zxcvbn'
require 'bcrypt'
require 'faker'

passwords_file = "10_million_password_list_top_10000.txt"
passwords = open(passwords_file).readlines

puts "name,email,entropy,password"
passwords.each do |password|
  password = password.chomp

  name          = Faker::Name.name
  email         = Faker::Internet.email
  entropy       = Zxcvbn.test(password, []).entropy
  encrypted_pwd = BCrypt::Password.create(password)

  puts "#{name},#{email},#{entropy},#{encrypted_pwd}"
end

