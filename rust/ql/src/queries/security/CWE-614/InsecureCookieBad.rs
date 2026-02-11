use cookie::Cookie;

// BAD: creating a cookie without specifying the `secure` attribute
let cookie = Cookie::build(("session", "abcd1234")).build();
let mut jar = cookie::CookieJar::new();
jar.add(cookie.clone());
