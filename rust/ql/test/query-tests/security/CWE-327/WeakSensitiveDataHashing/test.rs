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
    _ = md5::Md5::digest(credit_card_no); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    _ = md5::Md5::digest(password); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    _ = md5::Md5::digest(encrypted_password);

    // MD5 (alternative / older library)
    _ = md5_alt::compute(harmless); // $ Alert[rust/summary/cryptographic-operations]
    _ = md5_alt::compute(credit_card_no); // $ Alert[rust/summary/cryptographic-operations] Alert[rust/weak-sensitive-data-hashing]
    _ = md5_alt::compute(password); // $ Alert[rust/summary/cryptographic-operations] Alert[rust/weak-sensitive-data-hashing]
    _ = md5_alt::compute(encrypted_password); // $ Alert[rust/summary/cryptographic-operations]

    // SHA-1
    _ = sha1::Sha1::digest(harmless);
    _ = sha1::Sha1::digest(credit_card_no); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    _ = sha1::Sha1::digest(password); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    _ = sha1::Sha1::digest(encrypted_password);

    // SHA-1 checked
    _ = sha1_checked::Sha1::digest(harmless);
    _ = sha1_checked::Sha1::digest(credit_card_no); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    _ = sha1_checked::Sha1::digest(password); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    _ = sha1_checked::Sha1::digest(encrypted_password);

    // SHA-256 (appropriate for sensitive data hashing)
    _ = sha3::Sha3_256::digest(harmless);
    _ = sha3::Sha3_256::digest(credit_card_no);
    _ = sha3::Sha3_256::digest(password); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
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
    _ = md5::Md5::digest(password_str); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    _ = md5::Md5::digest(harmless_arr);
    _ = md5::Md5::digest(password_arr); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    _ = md5::Md5::digest(harmless_vec);
    _ = md5::Md5::digest(password_vec); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]

    // hash through a hasher object
    let mut md5_hasher = md5::Md5::new(); // $ Alert[rust/summary/cryptographic-operations]
    md5_hasher.update(b"abc");
    md5_hasher.update(harmless);
    md5_hasher.update(password); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    _ = md5_hasher.finalize();

    _ = md5::Md5::new().chain_update(harmless).chain_update(harmless).chain_update(harmless).finalize(); // $ Alert[rust/summary/cryptographic-operations]
    _ = md5::Md5::new().chain_update(harmless).chain_update(password).chain_update(harmless).finalize(); // $ Alert[rust/summary/cryptographic-operations] MISSING: Alert[rust/weak-sensitive-data-hashing]

    _ = md5::Md5::new_with_prefix(harmless).finalize();
    _ = md5::Md5::new_with_prefix(password).finalize(); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]

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
    let mut md5_hasher = md5::Md5::new(); // $ Alert[rust/summary/cryptographic-operations]
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

    let mut md5_hasher = md5::Md5::new(); // $ Alert[rust/summary/cryptographic-operations]
    _ = std::io::copy(&mut harmless_file, &mut md5_hasher);
    _ = std::io::copy(&mut password_file, &mut md5_hasher); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    _ = md5_hasher.finalize();
}

// ---

struct Seed {
}

impl Seed {
    fn new() -> Self {
        Seed { }
    }
}

fn test_seed() {
    // this will be misrecognized as a use of the SEED algorithm, but being a strong
    // algorithm there is no query result anyway.
    let _ = Seed::new(); // $ Alert[rust/summary/cryptographic-operations]
}

// ---

struct Sha1 {
}

impl Sha1 {
    const fn new() -> Self {
        Sha1 { }
    }

    const fn update(&mut self, _data: &[u8]) {
        // ...
    }

    const fn finalize(self) -> [u8; 20] {
        [0; 20]
    }
}

fn sha1_test(password: &[u8]) {
    let mut hasher = Sha1::new(); // $ Alert[rust/summary/cryptographic-operations]
    hasher.update(password); // $ MISSING: Alert[rust/weak-sensitive-data-hashing]
    _ = hasher.finalize();
}

// ---

struct HashCollection {
}

impl HashCollection {
    pub fn add_sig(value: &str) -> Self {
        _ = md5_alt::compute(value); // $ Alert[rust/summary/cryptographic-operations] Alert[rust/weak-sensitive-data-hashing]

        // ...

        HashCollection { }
    }
}

fn test_hash_collection() {
    // this indirectly performs MD5 hashing, but the data is not sensitive
    let id: &str = "my_id_1234567890";
    HashCollection::add_sig(id);

    // this indirectly performs MD5 hashing, and the data is sensitive; the result is reported here
    let password: &str = "password123";
    HashCollection::add_sig(password); // $ Source
}
