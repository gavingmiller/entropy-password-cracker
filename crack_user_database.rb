require 'zxcvbn'
require 'pry'
require 'sqlite3'
require 'bcrypt'

tester = Zxcvbn::Tester.new
entropies = {}

passwords = open("password_dictionaries/10_million_password_list_top_10000.txt").readlines

puts "Reading common passwords"
start_time = Time.now
passwords.each do |password|
  password = password.chomp
  entropy = tester.test(password)

  entropies[entropy.entropy] ||= []
  entropies[entropy.entropy] << password
end
end_time = Time.now

time = end_time - start_time
puts "Finished entropy collection; #{passwords.count} passwords in #{time}s"

# Open a SQLite 3 database file
db = SQLite3::Database.new('db/entropy.sqlite3')

db.execute("SELECT * FROM users ORDER BY entropy") do |user|
  email       = user[1]
  pwd_hash    = user[4]
  pwd_entropy = user[5]

  puts "User: #{email}, entropy: #{pwd_entropy}, password_hash: #{pwd_hash} "

  candidate_passwords = entropies[pwd_entropy]
  if candidate_passwords != nil
    passwords = candidate_passwords.select do |candidate|
      BCrypt::Password.new(pwd_hash) == candidate
    end.flatten

    # Should be 0 or 1 -- if > 1, something wrong
    if passwords.length == 0
      puts "No Matching Candidates"
    elsif passwords.length == 1
      puts "Password is: #{passwords.first}"
    end
  else
    puts "No Candidates Found"
  end
end
