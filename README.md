# Password Cracker Based on Leaked Entropy in a Database

This project demonstrates how password entropy saved alongside a password hash can be used to significantly
reduce the time required to crack hashed passwords.

For a further explanation see: http://gavinmiller.io/2016/a-tale-of-security-gone-wrong/

## How to Use

* Clone the project: `git clone git@github.com:gavingmiller/entropy-password-cracker.git`
* Install the required libraries: `bundle install`
** You may need to install SQLite3 bindings, e.g.:
*** `port install sqlite3 +universal`
*** `yum install sqlite-devel`
*** `apt-get install libsqlite3-dev`
* Crack the user database: `ruby crack_user_database.rb`
* `generate_user_database.rb` is available for you to modify/play with
