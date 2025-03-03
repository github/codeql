
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

    let const1: &[u8;16] = &[0u8;16]; // $ MISSING: Alert[rust/hardcoded-crytographic-value]
    let mut rabbit_cipher2 = RabbitKeyOnly::new(rabbit::Key::from_slice(const1));
    rabbit_cipher2.apply_keystream(&mut data);

    let mut rabbit_cipher3 = Rabbit::new(rabbit::Key::from_slice(key), rabbit::Iv::from_slice(iv));
    rabbit_cipher3.apply_keystream(&mut data);

    let const2: &[u8;16] = &[0u8;16]; // $ MISSING: Alert[rust/hardcoded-crytographic-value]
    let mut rabbit_cipher4 = Rabbit::new(rabbit::Key::from_slice(const2), rabbit::Iv::from_slice(iv));
    rabbit_cipher4.apply_keystream(&mut data);

    let const3: &[u8;16] = &[0u8;16]; // $ MISSING: Alert[rust/hardcoded-crytographic-value]
    let mut rabbit_cipher5 = Rabbit::new(rabbit::Key::from_slice(key), rabbit::Iv::from_slice(const3));
    rabbit_cipher5.apply_keystream(&mut data);

    let const4: &[u8;16] = &[0u8;16]; // (unused, so good)
}

fn test_block_cipher_aes(
    key: &[u8], iv: &[u8], key256: &[u8;32],
    block128: &mut [u8;16], input: &[u8], output: &mut [u8]
) {
    // aes

    let aes_cipher1 = Aes256::new(key256.into());
    aes_cipher1.encrypt_block(block128.into());

    let const1 = &[0u8;32]; // $ MISSING: Alert[rust/hardcoded-crytographic-value]
    let aes_cipher2 = Aes256::new(const1.into());
    aes_cipher2.encrypt_block(block128.into());

    let aes_cipher3 = Aes256::new_from_slice(key256).unwrap();
    aes_cipher3.encrypt_block(block128.into());

    let const2 = &[0u8;32]; // $ MISSING: Alert[rust/hardcoded-crytographic-value]
    let aes_cipher4 = Aes256::new_from_slice(const2).unwrap();
    aes_cipher4.encrypt_block(block128.into());

    let aes_cipher5 = cfb_mode::Encryptor::<aes::Aes256>::new(key.into(), iv.into());
    _ = aes_cipher5.encrypt_b2b(input, output).unwrap();

    let const3 = &[0u8;32]; // $ MISSING: Alert[rust/hardcoded-crytographic-value]
    let aes_cipher6 = cfb_mode::Encryptor::<aes::Aes256>::new(const3.into(), iv.into());
    _ = aes_cipher6.encrypt_b2b(input, output).unwrap();

    let const4 = &[0u8; 16]; // $ MISSING: Alert[rust/hardcoded-crytographic-value]
    let aes_cipher7 = cfb_mode::Encryptor::<aes::Aes256>::new(key.into(), const4.into());
    _ = aes_cipher7.encrypt_b2b(input, output).unwrap();
}
