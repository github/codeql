let des_cipher = cbc::Encryptor::<des::Des>::new(key.into(), iv.into()); // BAD: weak encryption
let encryption_result = des_cipher.encrypt_padded_mut::<des::cipher::block_padding::Pkcs7>(data, data_len);
