require 'zxcvbn'
require 'pry'
require 'sqlite3'
require 'bcrypt'

tester = Zxcvbn::Tester.new
entropies = {}

passwords = open("common_passwords.txt").readlines

start_time = Time.now
passwords.each do |password|
  password = password.chomp
  entropy = tester.test(password)

  entropies[entropy.entropy] ||= []
  entropies[entropy.entropy] << password
end
end_time = Time.now

time = end_time - start_time
puts "Finished entropy collection; 10,000 passwords in #{time}s"
# gets

# Open a SQLite 3 database file
db = SQLite3::Database.new 'entropy.sqlite3'

db.execute("SELECT * FROM users") do |user|
  email    = user[1]
  password = user[6]
  entropy  = user[7]

  candidate_passwords = entropies[entropy]
  if candidate_passwords != nil
    puts "  For user: #{email}"
    puts "   Entropy: #{entropy}"
    puts "  Password: #{password}"
    print "Candidates: "

    candidate_passwords.each do |candidate|
      print candidate
      if BCrypt::Password.new(password) == candidate
        print "       <--- matched (╯°Д°)╯︵ ┻━┻"
        puts
      else
        puts
      end
      print "            "
    end
  else
    puts "  For user: #{email}"
    puts "   Entropy: #{entropy}"
    puts "  Password: #{password}"
    puts "Candidates: None Found"
    puts ""
  end

  gets
end
