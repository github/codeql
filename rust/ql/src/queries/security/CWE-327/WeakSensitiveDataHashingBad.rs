// MD5 is not appropriate for hashing sensitive data.
let mut md5_hasher = md5::Md5::new();
...
md5_hasher.update(emergency_contact); // BAD
md5_hasher.update(credit_card_no); // BAD
...
my_hash = md5_hasher.finalize();

// SHA3-256 is not appropriate for hashing passwords.
my_hash = sha3::Sha3_256::digest(password); // BAD
