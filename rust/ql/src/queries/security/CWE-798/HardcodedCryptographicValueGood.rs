let key = Aes256Gcm::generate_key(aes_gcm::aead::OsRng); // GOOD: Using randomly generated keys for encryption
let cipher = Aes256Gcm::new(&key);
