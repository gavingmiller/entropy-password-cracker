require 'zxcvbn'
require 'bcrypt'
require 'faker'
require 'sqlite3'
require 'fileutils'

# Password file downloaded from:
# https://github.com/danielmiessler/SecLists/tree/master/Passwords
password_file = 'password_dictionaries/10_million_password_list_top_10000.txt'
database_file = 'db/entropy.sqlite3'
tester = Zxcvbn::Tester.new
threads = 4

puts "Deleting old database"
FileUtils.rm database_file

puts "Creating new database"
SQLite3::Database.new(database_file) do |db|

  db.execute(<<-SQL)
    CREATE TABLE users (
      id            INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      email         VARCHAR,
      first_name    VARCHAR,
      last_name     VARCHAR,
      password_hash CHAR(60),
      entropy       REAL
    )
  SQL

  puts "Filling new database"
  puts "This will take a bit, because BCrypt is slow! Grab a coffee."

  File.readlines(password_file).map(&:chomp).each do |password|
    params = [
      Faker::Internet.email,
      Faker::Name.first_name,
      Faker::Name.last_name,
      BCrypt::Password.create(password),
      tester.test(password).entropy
    ]

    db.execute(<<-SQL, params)
      INSERT INTO users (email, first_name, last_name, password_hash, entropy)
      VALUES (?, ?, ?, ?, ?);
    SQL

    print "."

  end

end
