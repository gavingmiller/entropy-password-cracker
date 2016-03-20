# Password Cracker Based on Leaked Entropy in a Database

This project demonstrates how password entropy saved alongside a password hash can be used to significantly
reduced the time required to crack passwords in the database.

For a further explanation of the project see: http://gavinmiller.io/2016/a-curious-tale-of-security-gone-awry/

## How to Use

* Clone the project: `git clone _____`
* Crack the user database: `ruby crack_user_database.rb`

### Details


* Generate the user database: `ruby generate_user_database.rb`


Passwords:
https://github.com/danielmiessler/SecLists/tree/master/Passwords

Use BCrypt information found here:
https://github.com/codahale/bcrypt-ruby

* main.rb contains passwords to Zxcvbn
* hash.rb contains passwords to BCrypt

There's a new algorithm known as Argon2 which will be the next BCrypt and adds costs
such as memory, and parallelism: https://password-hashing.net/
