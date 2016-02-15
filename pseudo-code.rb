

# THIS NEEDS TO BE BETTER
#   Create a diagram!
Foreach password in common-password.txt
  Zxcvbn(password) && save-in-memory

Foreach user in DB
  Check if passwords exist for entropy
    Foreach match
      bcrypt(candidate-password) =? user.password_hash

