use cookie::Cookie;

// GOOD: set the `CookieBuilder` 'Secure' attribute so that the cookie is only sent over HTTPS
let secure_cookie = Cookie::build(("session", "abcd1234")).secure(true).build();
let mut jar = cookie::CookieJar::new();
jar.add(secure_cookie.clone());

// GOOD: alternatively, set the 'Secure' attribute on an existing `Cookie`
let mut secure_cookie2 = Cookie::new("session", "abcd1234");
secure_cookie2.set_secure(true);
jar.add(secure_cookie2);
