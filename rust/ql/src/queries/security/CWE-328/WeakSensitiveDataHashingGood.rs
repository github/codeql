// SHA3-256 *is* appropriate for hashing sensitive data.
let mut sha3_256_hasher = sha3::Sha3_256::new();
...
sha3_256_hasher.update(emergency_contact); // GOOD
sha3_256_hasher.update(credit_card_no); // GOOD
...
my_hash = sha3_256_hasher.finalize();

// Argon2 is appropriate for hashing passwords.
let argon2_salt = argon2::password_hash::Salt::from_b64(salt)?;
my_hash = argon2::Argon2::default().hash_password(password.as_bytes(), argon2_salt)?.to_string(); // GOOD
