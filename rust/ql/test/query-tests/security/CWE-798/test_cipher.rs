
use cipher::{consts::*, StreamCipher, AsyncStreamCipher, KeyInit, KeyIvInit, BlockEncrypt};
use rabbit::{Rabbit, RabbitKeyOnly};
use aes::Aes256;

// --- tests ---

fn test_stream_cipher_rabbit(
    key: &[u8;16], iv: &[u8;16], plaintext: &str
) {
    let mut data = plaintext.as_bytes().to_vec();

    // rabbit

    let mut rabbit_cipher1 = RabbitKeyOnly::new(rabbit::Key::from_slice(key));
    rabbit_cipher1.apply_keystream(&mut data);

    let const1: &[u8;16] = &[0u8;16]; // $ Alert[rust/hardcoded-cryptographic-value]
    let mut rabbit_cipher2 = RabbitKeyOnly::new(rabbit::Key::from_slice(const1)); // $ Sink
    rabbit_cipher2.apply_keystream(&mut data);

    let mut rabbit_cipher3 = Rabbit::new(rabbit::Key::from_slice(key), rabbit::Iv::from_slice(iv));
    rabbit_cipher3.apply_keystream(&mut data);

    let const4: &[u8;16] = &[0u8;16]; // $ Alert[rust/hardcoded-cryptographic-value]
    let mut rabbit_cipher4 = Rabbit::new(rabbit::Key::from_slice(const4), rabbit::Iv::from_slice(iv)); // $ Sink
    rabbit_cipher4.apply_keystream(&mut data);

    let const5: &[u8;16] = &[0u8;16]; // $ Alert[rust/hardcoded-cryptographic-value]
    let mut rabbit_cipher5 = Rabbit::new(rabbit::Key::from_slice(key), rabbit::Iv::from_slice(const5)); // $ Sink
    rabbit_cipher5.apply_keystream(&mut data);

    // various expressions of constant arrays

    let const6: &[u8;16] = &[0u8;16]; // (unused, so good)

    let const7: [u8;16] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; // $ Alert[rust/hardcoded-cryptographic-value]
    let mut rabbit_cipher7 = RabbitKeyOnly::new(rabbit::Key::from_slice(&const7)); // $ Sink
    rabbit_cipher7.apply_keystream(&mut data);

    let const8: &[u8;16] = &[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; // $ Alert[rust/hardcoded-cryptographic-value]
    let mut rabbit_cipher8 = RabbitKeyOnly::new(rabbit::Key::from_slice(const8)); // $ Sink
    rabbit_cipher8.apply_keystream(&mut data);

    let const9: [u16;8] = [0, 0, 0, 0, 0, 0, 0, 0]; // $ Alert[rust/hardcoded-cryptographic-value]
    let const9_conv = unsafe { const9.align_to::<u8>().1 }; // convert [u16;8] -> [u8;8]
    let mut rabbit_cipher9 = RabbitKeyOnly::new(rabbit::Key::from_slice(const9_conv)); // $ Sink
    rabbit_cipher9.apply_keystream(&mut data);

    let const10: [u8;16] = unsafe { std::mem::zeroed() }; // $ Alert[rust/hardcoded-cryptographic-value]
    let mut rabbit_cipher10 = RabbitKeyOnly::new(rabbit::Key::from_slice(&const10)); // $ Sink
    rabbit_cipher10.apply_keystream(&mut data);
}

use base64::Engine;

fn test_block_cipher_aes(
    key: &[u8], iv: &[u8], key256: &[u8;32], key_str: &str,
    block128: &mut [u8;16], input: &[u8], output: &mut [u8]
) {
    // aes

    let aes_cipher1 = Aes256::new(key256.into());
    aes_cipher1.encrypt_block(block128.into());

    let const2 = &[0u8;32]; // $ Alert[rust/hardcoded-cryptographic-value]
    let aes_cipher2 = Aes256::new(const2.into()); // $ Sink
    aes_cipher2.encrypt_block(block128.into());

    let aes_cipher3 = Aes256::new_from_slice(key256).unwrap();
    aes_cipher3.encrypt_block(block128.into());

    let const2 = &[0u8;32]; // $ Alert[rust/hardcoded-cryptographic-value]
    let aes_cipher4 = Aes256::new_from_slice(const2).unwrap(); // $ Sink
    aes_cipher4.encrypt_block(block128.into());

    let aes_cipher5 = cfb_mode::Encryptor::<aes::Aes256>::new(key.into(), iv.into());
    _ = aes_cipher5.encrypt_b2b(input, output).unwrap();

    let const6 = &[0u8;32]; // $ Alert[rust/hardcoded-cryptographic-value]
    let aes_cipher6 = cfb_mode::Encryptor::<aes::Aes256>::new(const6.into(), iv.into()); // $ Sink
    _ = aes_cipher6.encrypt_b2b(input, output).unwrap();

    let const7 = &[0u8; 16]; // $ Alert[rust/hardcoded-cryptographic-value]
    let aes_cipher7 = cfb_mode::Encryptor::<aes::Aes256>::new(key.into(), const7.into()); // $ Sink
    _ = aes_cipher7.encrypt_b2b(input, output).unwrap();

    // various string conversions

    let key8: &[u8] = key_str.as_bytes();
    let aes_cipher8 = cfb_mode::Encryptor::<aes::Aes256>::new(key8.into(), iv.into());
    _ = aes_cipher8.encrypt_b2b(input, output).unwrap();

    let key9: &[u8] = "1234567890123456".as_bytes(); // $ MISSING: Alert[rust/hardcoded-cryptographic-value]
    let aes_cipher9 = cfb_mode::Encryptor::<aes::Aes256>::new(key9.into(), iv.into());
    _ = aes_cipher9.encrypt_b2b(input, output).unwrap();

    let key10: [u8; 32] = match base64::engine::general_purpose::STANDARD.decode(key_str) {
        Ok(x) => x.try_into().unwrap(),
        Err(_) => "1234567890123456".as_bytes().try_into().unwrap() // $ MISSING: Alert[rust/hardcoded-cryptographic-value]
    };
    let aes_cipher10 = Aes256::new(&key10.into());
    aes_cipher10.encrypt_block(block128.into());

    if let Ok(const11) = base64::engine::general_purpose::STANDARD.decode("1234567890123456") { // $ MISSING: Alert[rust/hardcoded-cryptographic-value]
        let key11: [u8; 32] = const11.try_into().unwrap();
        let aes_cipher11 = Aes256::new(&key11.into());
        aes_cipher11.encrypt_block(block128.into());
    }
}

use aes_gcm::aead::{Aead, AeadCore, OsRng};
use aes_gcm::{Aes256Gcm, Key, Nonce};

fn test_aes_gcm(
) {
    // aes (GCM)

    let key1 = Aes256Gcm::generate_key(aes_gcm::aead::OsRng);
    let nonce1 = Aes256Gcm::generate_nonce(aes_gcm::aead::OsRng);
    let cipher1 = Aes256Gcm::new(&key1);
    let _ = cipher1.encrypt(&nonce1, b"plaintext".as_ref()).unwrap();

    let key2: [u8;32] = [0;32]; // $ Alert[rust/hardcoded-cryptographic-value]
    let nonce2 = [0;12]; // $ Alert[rust/hardcoded-cryptographic-value]
    let cipher2 = Aes256Gcm::new(&key2.into()); // $ Sink
    let _ = cipher2.encrypt(&nonce2.into(), b"plaintext".as_ref()).unwrap(); // $ Sink

    let key3_array: &[u8;32] = &[0xff;32]; // $ Alert[rust/hardcoded-cryptographic-value]
    let key3 = Key::<Aes256Gcm>::from_slice(key3_array);
    let nonce3: [u8;12] = [0xff;12]; // $ Alert[rust/hardcoded-cryptographic-value]
    let cipher3 = Aes256Gcm::new(&key3); // $ Sink
    let _ = cipher3.encrypt(&nonce3.into(), b"plaintext".as_ref()).unwrap(); // $ Sink

    // with barrier

    let mut key4 = [0u8;32]; // $ SPURIOUS: Alert[rust/hardcoded-cryptographic-value]
    let mut nonce4 = [0u8;12]; // $ SPURIOUS: Alert[rust/hardcoded-cryptographic-value]
    _ = getrandom::fill(&mut key4).unwrap();
    _ = getrandom2::getrandom(&mut nonce4).unwrap();
    let cipher4 = Aes256Gcm::new(&key4.into()); // $ Sink
    let _ = cipher2.encrypt(&nonce4.into(), b"plaintext".as_ref()).unwrap(); // $ Sink
}
