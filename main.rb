require 'zxcvbn'

passwords_file = "10_million_password_list_top_10000.txt"
passwords = open(passwords_file).readlines

passwords.take(10).each do |password|
  password = password.chomp
  puts "#{password}:\t#{Zxcvbn.test(password, []).entropy}"
end

