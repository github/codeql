let aes_cipher = cbc::Encryptor::<aes::Aes256>::new(key.into(), iv.into()); // GOOD: strong encryption
let encryption_result = aes_cipher.encrypt_padded_mut::<aes::cipher::block_padding::Pkcs7>(data, data_len);
