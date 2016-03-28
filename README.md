# Password Cracker Based on Leaked Entropy in a Database

This project demonstrates how password entropy saved alongside a password hash can be used to significantly
reduce the time required to crack hashed passwords.

For a further explanation see: http://gavinmiller.io/2016/a-curious-tale-of-security-gone-awry/

## How to Use

* Clone the project: `git clone git@github.com:gavingmiller/entropy-password-cracker.git`
* Crack the user database: `ruby crack_user_database.rb`
* `generate_user_database.rb` is available for you to modify/play with
