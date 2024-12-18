SecureRandom r = new SecureRandom();

byte[] bytes = new byte[16];
r.nextBytes(bytes);

String cookieValue = encode(bytes);

Cookie cookie = new Cookie("name", cookieValue);
response.addCookie(cookie);
