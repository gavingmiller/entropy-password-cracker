require 'zxcvbn'
require 'bcrypt'
require 'faker'
require 'sqlite3'
require 'fileutils'

# Password file downloaded from:
# https://github.com/danielmiessler/SecLists/tree/master/Passwords
passwords_file = "password_dictionaries/10_million_password_list_top_10000.txt"
passwords = open(passwords_file).readlines

puts "Deleting old database"
database_name = 'db/entropy.sqlite3'
FileUtils.rm(database_name)

puts "Creating new database"
db = SQLite3::Database.new(database_name)
db.execute(<<-EOL
  CREATE TABLE `users` (
    `id`  INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    `email`       varchar,
    `first_name`  varchar,
    `last_name`   varchar,
    `password`    varchar,
    `entropy`     real,
    `created_at`  datetime NOT NULL,
    `updated_at`  datetime NOT NULL
  );
  EOL
)

puts "Filling new database"
puts "This will take a bit, because BCrypt is slow! Grab a coffee."
passwords.each do |password|
  password = password.chomp

  first_name  = Faker::Name.first_name
  last_name   = Faker::Name.last_name
  email       = Faker::Internet.email
  entropy     = Zxcvbn.test(password, []).entropy
  hashed_pwd  = BCrypt::Password.create(password)

  sql = <<-EOL
  INSERT INTO Users
  (email, first_name, last_name, password, entropy, created_at, updated_at)
  VALUES (
    "#{email}",
    "#{first_name}",
    "#{last_name}",
    "#{hashed_pwd}",
    "#{entropy}",
    "#{DateTime.now}",
    "#{DateTime.now}"
  );
  EOL

  db.execute(sql)
  print "."
end

