require 'argon2'

def get_initial_hash(password)
  Argon2::Password.create(password)
end

def check_password(password, known_hash)
  Argon2::Password.verify_password(password, known_hash)
end
