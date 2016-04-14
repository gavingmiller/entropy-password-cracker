require 'zxcvbn'
require 'bcrypt'
require 'faker'
require 'sqlite3'
require 'fileutils'
require 'parallel'

# Password file downloaded from:
# https://github.com/danielmiessler/SecLists/tree/master/Passwords
processes = 8
password_file = 'password_dictionaries/10_million_password_list_top_10000.txt'
database_file = 'db/entropy.sqlite3'


tester = Zxcvbn::Tester.new
puts "Calculating BCrypt hashes in #{processes} processes"
data = Parallel.each_with_index(File.readlines(password_file).map(&:chomp), in_processes: processes) do |password, i|
  print "." if i % 100 == 0
  [
    Faker::Internet.email,
    Faker::Name.first_name,
    Faker::Name.last_name,
    BCrypt::Password.create(password),
    tester.test(password).entropy
  ]
end
puts ""


if File.exists? database_file
  puts "Deleting old database: #{database_file}"
  FileUtils.rm database_file
end


puts "Creating new database"
SQLite3::Database.new(database_file) do |db|
  db.transaction do
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

    insert = db.prepare <<-SQL
      INSERT INTO users (email, first_name, last_name, password_hash, entropy)
      VALUES (?, ?, ?, ?, ?)
    SQL

    data.each_with_index do |params, i|
      print "." if i % 100 == 0
      insert.execute params
    end

    insert.close
  end
  puts ""

end
