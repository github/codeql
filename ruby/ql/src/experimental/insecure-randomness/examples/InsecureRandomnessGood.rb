require 'securerandom'

def generate_password()
  chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + ['!', '@', '#', '$', '%']

  # GOOD: SecureRandom is cryptographically secure
  password = SecureRandom.random_bytes(10).each_byte.map do |byte|
    chars[byte % chars.length]
  end.join
end

password = generate_password()