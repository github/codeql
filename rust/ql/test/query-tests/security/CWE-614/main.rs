use cookie::{Cookie, CookieBuilder, CookieJar, Key};

fn test_cookie(sometimes: bool) {
    let always = true;
    let never = false;

    // secure set to false
    let cookie1 = Cookie::build(("name", "value")).secure(false).build(); // $ MISSING: Alert[rust/insecure-cookie]
    println!("cookie1 = '{}'", cookie1.to_string());

    // secure set to true
    let cookie2 = Cookie::build(("name", "value")).secure(true).build(); // good
    println!("cookie2 = '{}'", cookie2.to_string());

    // secure left as default (which is `None`, equivalent here to `false`)
    let cookie3 = Cookie::build(("name", "value")).build(); // $ MISSING: Alert[rust/insecure-cookie]
    println!("cookie3 = '{}'", cookie3.to_string());

    // secure setting varies (may be false)
    Cookie::build(("name", "value")).secure(sometimes).build(); // $ MISSING: Alert[rust/insecure-cookie]
    Cookie::build(("name", "value")).secure(!sometimes).build(); // $ MISSING: Alert[rust/insecure-cookie]

    // with data flow on the "secure" value
    Cookie::build(("name", "value")).secure(always).build(); // good
    Cookie::build(("name", "value")).secure(!always).build(); // $ MISSING: Alert[rust/insecure-cookie]
    Cookie::build(("name", "value")).secure(never).build(); // $ MISSING: Alert[rust/insecure-cookie]
    Cookie::build(("name", "value")).secure(!never).build(); // good
    Cookie::build(("name", "value")).secure(always && never).build(); // $ MISSING: Alert[rust/insecure-cookie]
    Cookie::build(("name", "value")).secure(always || never).build(); // good

    // with guards
    if sometimes {
        Cookie::build(("name", "value")).secure(sometimes).build(); // good
    } else {
        Cookie::build(("name", "value")).secure(sometimes).build(); // $ MISSING: Alert[rust/insecure-cookie]
    }

    // variant uses (all insecure)
    CookieBuilder::new("name", "value").secure(false).build(); // $ MISSING: Alert[rust/insecure-cookie]
    Cookie::build(("name", "value")).expires(None).secure(false).build(); // $ MISSING: Alert[rust/insecure-cookie]
    Cookie::build(("name", "value")).max_age(cookie::time::Duration::hours(12)).secure(false).build(); // $ MISSING: Alert[rust/insecure-cookie]
    Cookie::build(("name", "value")).domain("example.com").secure(false).build(); // $ MISSING: Alert[rust/insecure-cookie]
    Cookie::build(("name", "value")).path("/").secure(false).build(); // $ MISSING: Alert[rust/insecure-cookie]
    Cookie::build(("name", "value")).http_only(true).secure(false).build(); // $ MISSING: Alert[rust/insecure-cookie]
    Cookie::build(("name", "value")).same_site(cookie::SameSite::Strict).secure(false).build(); // $ MISSING: Alert[rust/insecure-cookie]
    Cookie::build(("name", "value")).permanent().secure(false).build(); // $ MISSING: Alert[rust/insecure-cookie]
    Cookie::build(("name", "value")).removal().secure(false).build(); // $ MISSING: Alert[rust/insecure-cookie]
    Cookie::build(("name", "value")).secure(false).finish(); // $ MISSING: Alert[rust/insecure-cookie]
    Cookie::build("name").secure(false).build(); // $ MISSING: Alert[rust/insecure-cookie]
    Cookie::build(Cookie::build("name")).secure(false).build(); // $ MISSING: Alert[rust/insecure-cookie]

    // edge cases
    Cookie::build(("name", "value")).secure(true).secure(false).build(); // $ MISSING: Alert[rust/insecure-cookie]
    Cookie::build(("name", "value")).secure(false).secure(true).build(); // good

    // mutable cookie
    let mut jar = CookieJar::new();
    let mut a = Cookie::new("name", "value");
    jar.add(a.clone()); // $ MISSING: Alert[rust/insecure-cookie]
    jar.add_original(a.clone()); // $ MISSING: Alert[rust/insecure-cookie]
    a.set_secure(true);
    jar.add(a.clone()); // good
    a.set_secure(false);
    jar.add(a.clone()); // $ MISSING: Alert[rust/insecure-cookie]

    let key = Key::generate();
    let mut signed_jar = jar.signed_mut(&key);
    let mut b = Cookie::named("name");
    signed_jar.add(b.clone()); // $ MISSING: Alert[rust/insecure-cookie]
    signed_jar.add_original(a.clone()); // $ MISSING: Alert[rust/insecure-cookie]
    b.set_secure(sometimes);
    signed_jar.add(b.clone()); // $ MISSING: Alert[rust/insecure-cookie]
    b.set_secure(true);
    signed_jar.add(b.clone()); // good

    let mut private_jar = jar.private_mut(&key);
    let mut c = Cookie::from("name");
    private_jar.add(c.clone()); // $ MISSING: Alert[rust/insecure-cookie]
    private_jar.add_original(a.clone()); // $ MISSING: Alert[rust/insecure-cookie]
    if sometimes {
        c.set_secure(true);
    }
    private_jar.add(c.clone()); // $ MISSING: Alert[rust/insecure-cookie]
    c.set_secure(true);
    private_jar.add(c.clone()); // good

    let mut d = Cookie::from("name");
    jar.add(d.clone()); // $ MISSING: Alert[rust/insecure-cookie]
    if sometimes {
        c.set_secure(true);
    } else {
        c.set_partitioned(true);
    }
    jar.add(d.clone()); // good

    // parse
    jar.add(Cookie::parse("name=value; HttpOnly").unwrap()); // $ MISSING: Alert[rust/insecure-cookie]
    jar.add(Cookie::parse("name=value; Secure; HttpOnly").unwrap()); // good
    jar.add(Cookie::parse_encoded("name=value; HttpOnly").unwrap()); // $ MISSING: Alert[rust/insecure-cookie]
    jar.add(Cookie::parse_encoded("name=value; Secure; HttpOnly").unwrap()); // good

    for cookie in Cookie::split_parse("name1=value1; name2=value2") {
        jar.add(cookie.unwrap()); // $ MISSING: Alert[rust/insecure-cookie]
    }

    for cookie in Cookie::split_parse_encoded("name1=value1; name2=value2") {
        let mut e = cookie.unwrap();
        jar.add(e.clone()); // $ MISSING: Alert[rust/insecure-cookie]
        e.set_secure(true);
        jar.add(e.clone()); // good
    }

    // partitioned (implies secure)
    Cookie::build(("name", "value")).partitioned(true).build(); // good
}

fn test_biscotti() {
    let mut cookies = biscotti::ResponseCookies::new();

    // test set_secure, set_partitioned

    let a = biscotti::ResponseCookie::new("name", "value");
    cookies.insert(a.clone()); // $ MISSING: Alert[rust/insecure-cookie]
    println!("biscotti1 = {}", a.to_string());

    let b = a.set_secure(true);
    cookies.insert(b.clone()); // good (secure)
    println!("biscotti2 = {}", b.to_string());

    let c = b.set_secure(false);
    cookies.insert(c.clone()); // $ MISSING: Alert[rust/insecure-cookie]
    println!("biscotti3 = {}", c.to_string());

    let d = c.set_partitioned(true); // (implies secure)
    cookies.insert(d.clone()); // good (partitioned)
    println!("biscotti4 = {}", d.to_string());

    let e = d.set_secure(true);
    cookies.insert(e.clone()); // good (partitioned + secure)
    println!("biscotti5 = {}", e.to_string());

    let f = e.set_partitioned(false);
    cookies.insert(f.clone()); // good (secure)
    println!("biscotti6 = {}", f.to_string());

    let g = f.set_secure(false);
    cookies.insert(g.clone()); // $ MISSING: Alert[rust/insecure-cookie]
    println!("biscotti7 = {}", g.to_string());

    // variant creation (insecure)
    let h = biscotti::ResponseCookie::from(("name", "value"));
    cookies.insert(h); // $ MISSING: Alert[rust/insecure-cookie]

    // variant uses (all insecure)
    let i = biscotti::ResponseCookie::new("name", "value");
    cookies.insert(i.clone().set_name("name2")); // $ MISSING: Alert[rust/insecure-cookie]
    cookies.insert(i.clone().set_value("value2")); // $ MISSING: Alert[rust/insecure-cookie]
    cookies.insert(i.clone().set_http_only(true)); // $ MISSING: Alert[rust/insecure-cookie]
    cookies.insert(i.clone().set_same_site(biscotti::SameSite::Strict)); // $ MISSING: Alert[rust/insecure-cookie]
    cookies.insert(i.clone().set_max_age(None)); // $ MISSING: Alert[rust/insecure-cookie]
    cookies.insert(i.clone().set_path("/")); // $ MISSING: Alert[rust/insecure-cookie]
    cookies.insert(i.clone().unset_path()); // $ MISSING: Alert[rust/insecure-cookie]
    cookies.insert(i.clone().set_domain("example.com")); // $ MISSING: Alert[rust/insecure-cookie]
    cookies.insert(i.clone().unset_domain()); // $ MISSING: Alert[rust/insecure-cookie]
    cookies.insert(i.clone().set_expires(None)); // $ MISSING: Alert[rust/insecure-cookie]
    cookies.insert(i.clone().unset_expires()); // $ MISSING: Alert[rust/insecure-cookie]
    cookies.insert(i.clone().make_permanent()); // $ MISSING: Alert[rust/insecure-cookie]
}

fn main() {
    test_cookie(true);
    test_cookie(false);
    test_biscotti();
}
