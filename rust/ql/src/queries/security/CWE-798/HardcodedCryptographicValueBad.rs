let key: [u8;32] = [0;32]; // BAD: Using hard-coded keys for encryption
let cipher = Aes256Gcm::new(&key.into());
