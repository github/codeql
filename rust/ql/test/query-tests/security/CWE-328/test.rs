use md5::{Digest};
use serde::{Serialize};
use argon2::{PasswordHasher};

// --- tests ---

fn test_hash_algorithms(
    harmless: &str, credit_card_no: &str, password: &str, encrypted_password: &str, salt: &str
) {
    // test hashing with different algorithms and data

    // MD5
    _ = md5::Md5::digest(harmless);
    _ = md5::Md5::digest(credit_card_no); // $ Source Alert[rust/weak-sensitive-data-hashing]
    _ = md5::Md5::digest(password); // $ Source Alert[rust/weak-sensitive-data-hashing]
    _ = md5::Md5::digest(encrypted_password);

    // MD5 (alternative / older library)
    _ = md5_alt::compute(harmless);
    _ = md5_alt::compute(credit_card_no); // $ Source Alert[rust/weak-sensitive-data-hashing]
    _ = md5_alt::compute(password); // $ Source Alert[rust/weak-sensitive-data-hashing]
    _ = md5_alt::compute(encrypted_password);

    // SHA-1
    _ = sha1::Sha1::digest(harmless);
    _ = sha1::Sha1::digest(credit_card_no); // $ Source Alert[rust/weak-sensitive-data-hashing]
    _ = sha1::Sha1::digest(password); // $ Source Alert[rust/weak-sensitive-data-hashing]
    _ = sha1::Sha1::digest(encrypted_password);

    // SHA-1 checked
    _ = sha1_checked::Sha1::digest(harmless);
    _ = sha1_checked::Sha1::digest(credit_card_no); // $ Source Alert[rust/weak-sensitive-data-hashing]
    _ = sha1_checked::Sha1::digest(password); // $ Source Alert[rust/weak-sensitive-data-hashing]
    _ = sha1_checked::Sha1::digest(encrypted_password);

    // SHA-256 (appropriate for sensitive data hashing)
    _ = sha3::Sha3_256::digest(harmless);
    _ = sha3::Sha3_256::digest(credit_card_no);
    _ = sha3::Sha3_256::digest(password); // $ Source Alert[rust/weak-sensitive-data-hashing]
    _ = sha3::Sha3_256::digest(encrypted_password);

    // Argon2 (appropriate for password hashing)
    let argon2_salt = argon2::password_hash::Salt::from_b64(salt).unwrap();
    _ = argon2::Argon2::default().hash_password(harmless.as_bytes(), argon2_salt).unwrap().to_string();
    _ = argon2::Argon2::default().hash_password(credit_card_no.as_bytes(), argon2_salt).unwrap().to_string();
    _ = argon2::Argon2::default().hash_password(password.as_bytes(), argon2_salt).unwrap().to_string();
    _ = argon2::Argon2::default().hash_password(encrypted_password.as_bytes(), argon2_salt).unwrap().to_string();
}

fn test_hash_code_patterns(
    harmless: &str, password: &str,
    harmless_str: String, password_str: String,
    harmless_arr: &[u8], password_arr: &[u8],
    harmless_vec: Vec<u8>, password_vec: Vec<u8>
) {
    // test hashing with different code patterns

    // hash different types of data
    _ = md5::Md5::digest(harmless_str);
    _ = md5::Md5::digest(password_str); // $ Source Alert[rust/weak-sensitive-data-hashing]
    _ = md5::Md5::digest(harmless_arr);
    _ = md5::Md5::digest(password_arr); // $ Source Alert[rust/weak-sensitive-data-hashing]
    _ = md5::Md5::digest(harmless_vec);
    _ = md5::Md5::digest(password_vec); // $ Source Alert[rust/weak-sensitive-data-hashing]

    // hash through a hasher object
    let mut md5_hasher = md5::Md5::new();
    md5_hasher.update(b"abc");
    md5_hasher.update(harmless);
    md5_hasher.update(password); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    _ = md5_hasher.finalize();

    _ = md5::Md5::new().chain_update(harmless).chain_update(harmless).chain_update(harmless).finalize();
    _ = md5::Md5::new().chain_update(harmless).chain_update(password).chain_update(harmless).finalize(); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]

    _ = md5::Md5::new_with_prefix(harmless).finalize();
    _ = md5::Md5::new_with_prefix(password).finalize(); // $ Source Alert[rust/weak-sensitive-data-hashing]

    // hash transformed data
    _ = md5::Md5::digest(harmless.trim());
    _ = md5::Md5::digest(password.trim()); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    _ = md5::Md5::digest(harmless.as_bytes());
    _ = md5::Md5::digest(password.as_bytes()); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    _ = md5::Md5::digest(std::str::from_utf8(harmless_arr).unwrap());
    _ = md5::Md5::digest(std::str::from_utf8(password_arr).unwrap()); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
}

#[derive(Serialize)]
struct MyStruct1 {
    id: u64,
    data: String,
}

#[derive(Serialize)]
struct MyStruct2 {
    id: u64,
    credit_card_no: String,
}

#[derive(Serialize)]
struct MyStruct3 {
    id: u64,
    password: String,
}

fn test_hash_structs() {
    // test hashing with data in a struct
    let s1 = MyStruct1 {
        id: 1,
        data: "0123456789".to_string(),
    };
    let s2 = MyStruct2 {
        id: 2,
        credit_card_no: "0123456789".to_string(),
    };
    let s3 = MyStruct3 {
        id: 3,
        password: "0123456789".to_string(),
    };

    // serialize with serde
    let str1a = serde_json::to_string(&s1).unwrap();
    let str2a = serde_json::to_string(&s2).unwrap();
    let str3a = serde_json::to_string(&s3).unwrap();
    let str1b = serde_json::to_vec(&s1).unwrap();
    let str2b = serde_json::to_vec(&s2).unwrap();
    let str3b = serde_json::to_vec(&s3).unwrap();
    let str1c = serde_urlencoded::to_string(&s1).unwrap();
    let str2c = serde_urlencoded::to_string(&s2).unwrap();
    let str3c = serde_urlencoded::to_string(&s3).unwrap();

    // hash with MD5
    let mut md5_hasher = md5::Md5::new();
    md5_hasher.update(s1.data);
    md5_hasher.update(s2.credit_card_no); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    md5_hasher.update(s3.password); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    md5_hasher.update(str1a);
    md5_hasher.update(str2a); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    md5_hasher.update(str3a); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    md5_hasher.update(str1b);
    md5_hasher.update(str2b); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    md5_hasher.update(str3b); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    md5_hasher.update(str1c);
    md5_hasher.update(str2c); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    md5_hasher.update(str3c); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    _ = md5_hasher.finalize();
}

fn test_hash_file(
    harmless_filename: &str, password_filename: &str
) {
    // test hashing files
    let mut harmless_file = std::fs::File::open(harmless_filename).unwrap();
    let mut password_file = std::fs::File::open(password_filename).unwrap();

    let mut md5_hasher = md5::Md5::new();
    _ = std::io::copy(&mut harmless_file, &mut md5_hasher);
    _ = std::io::copy(&mut password_file, &mut md5_hasher); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    _ = md5_hasher.finalize();
}
