require 'zxcvbn'
require 'sqlite3'
require 'bcrypt'

password_file = 'password_dictionaries/10_million_password_list_top_10000.txt'
database_file = 'db/entropy.sqlite3'
tester = Zxcvbn::Tester.new

puts "Reading common passwords"
start_time = Time.now

entropies = File.readlines(password_file).map(&:chomp).each_with_object({}) do |password, obj|
  entropy = tester.test(password).entropy
  (obj[entropy] ||= []) << password
end

puts "Finished entropy collection in #{Time.now - start_time}s"

# Open a SQLite 3 database file
SQLite3::Database.new(database_file) do |db|

  sql = <<-SQL
    SELECT email, password_hash, entropy
    FROM users
    ORDER BY entropy
  SQL

  db.execute(sql) do |email, password_hash, entropy|

    puts "User: #{email}, entropy: #{entropy}, password_hash: #{password_hash}"

    next unless candidate_passwords = entropies[entropy]

    match = candidate_passwords.find do |candidate|
      BCrypt::Password.new(password_hash) == candidate
    end

    if match
      puts "Password is: #{match}"
    else
      puts "No Matching Candidates"
    end
  end
end
