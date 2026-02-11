Random r = new Random(); // BAD: Random is not cryptographically secure

byte[] bytes = new byte[16];
r.nextBytes(bytes);

String cookieValue = encode(bytes);

Cookie cookie = new Cookie("name", cookieValue);
response.addCookie(cookie);
