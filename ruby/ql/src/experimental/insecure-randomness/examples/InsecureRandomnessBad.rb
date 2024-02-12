def generate_password()
  chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + ['!', '@', '#', '$', '%']
  # BAD: rand is not cryptographically secure
  password = (1..10).collect { chars[rand(chars.size)] }.join
end

password = generate_password