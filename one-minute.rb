require 'benchmark'
require 'zxcvbn'
require 'bcrypt'

=begin
password = 'meep'
n = iterations = 10000
tester = Zxcvbn::Tester.new

Benchmark.bm() do |x|
  x.report("md5")    { n.times { Digest::MD5.hexdigest(password) } }
  x.report("zxcvbn") { n.times { tester.test(password, []).entropy } }
  x.report("bcrypt") { n.times { BCrypt::Password.create(password) } }
end
=end

start_time = `date "+%S"`.to_i
password = 'meep'
count = 0

while `date "+%S"`.to_i - start_time != 10
  Digest::MD5.hexdigest(password)
  count += 1
end

puts count / 10
