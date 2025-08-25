require 'securerandom'

def generate_password_1(length)
  chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + ['!', '@', '#', '$', '%']
  # BAD: rand is not cryptographically secure
  password = (1..length).collect { chars[rand(chars.size)] }.join
end

def generate_password_2(length)
  chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + ['!', '@', '#', '$', '%']

  # GOOD: SecureRandom is cryptographically secure
  password = SecureRandom.random_bytes(length).each_byte.map do |byte|
    chars[byte % chars.length]
  end.join
end

password = generate_password_1(10)
password = generate_password_2(10)