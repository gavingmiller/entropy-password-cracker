require 'benchmark'
require 'zxcvbn'
require 'bcrypt'
require 'digest/sha1'

password = 'meep'
n = iterations = 10000
tester = Zxcvbn::Tester.new

Benchmark.bm() do |x|
  #x.report("md5")    { n.times { Digest::MD5.hexdigest(password) } }
  #x.report("zxcvbn") { n.times { tester.test(password, []).entropy } }
  #x.report("bcrypt") { n.times { BCrypt::Password.create(password) } }
  x.report("sha1")   { n.times { Digest::SHA1.hexdigest(password) } }
end
