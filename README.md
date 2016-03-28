# Password Cracker Based on Leaked Entropy in a Database

This project demonstrates how password entropy saved alongside a password hash can be used to significantly
reduced the time required to crack passwords in the database.

For a further explanation of the project see: http://gavinmiller.io/2016/a-curious-tale-of-security-gone-awry/

## How to Use

* Clone the project: `git clone git@github.com:gavingmiller/entropy-password-cracker.git`
* Crack the user database: `ruby crack_user_database.rb`
* `generate_user_database.rb` is available for you to modify/play with
