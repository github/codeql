
use cipher::{consts::*, StreamCipher, KeyInit, KeyIvInit, BlockEncrypt, BlockDecrypt, BlockEncryptMut, BlockDecryptMut};
use rc4::{Rc4};
use rabbit::{Rabbit, RabbitKeyOnly};
use aes::{Aes128, Aes192Enc, Aes256Dec};
use des::{Des, TdesEde2, TdesEde3, TdesEee2, TdesEee3};
use rc2::{Rc2};
use rc5::{RC5_16_16_8, RC5_32_16_16};

// --- tests ---

fn test_stream_cipher(
    key128: &[u8;16], iv128: &[u8;16], plaintext: &str
) {
    let mut data = plaintext.as_bytes().to_vec();

    // rc4 (broken)
    let rc4_key = rc4::Key::<U16>::from_slice(key128);

    let mut rc4_cipher1 = Rc4::<_>::new(rc4_key); // $ Alert[rust/weak-cryptographic-algorithm]
    rc4_cipher1.apply_keystream(&mut data);

    let mut rc4_cipher2 = Rc4::<U16>::new_from_slice(key128).unwrap(); // $ Alert[rust/weak-cryptographic-algorithm]
    rc4_cipher2.apply_keystream(&mut data);

    let mut rc4_cipher3 = Rc4::<_>::new(rc4_key); // $ Alert[rust/weak-cryptographic-algorithm]
    let _ = rc4_cipher3.try_apply_keystream(&mut data);

    let mut rc4_cipher4 = Rc4::<_>::new(rc4_key); // $ Alert[rust/weak-cryptographic-algorithm]
    let _ = rc4_cipher4.apply_keystream_b2b(plaintext.as_bytes(), &mut data);

    // rabbit
    let rabbit_key = rabbit::Key::from_slice(key128);
    let rabbit_iv = rabbit::Iv::from_slice(iv128);

    let mut rabbit_cipher1 = RabbitKeyOnly::new(rabbit_key);
    rabbit_cipher1.apply_keystream(&mut data);

    let mut rabbit_cipher2 = Rabbit::new(rabbit_key, rabbit_iv);
    rabbit_cipher2.apply_keystream(&mut data);
}

fn test_block_cipher(
    key: &[u8], key128: &[u8;16], key192: &[u8;24], key256: &[u8;32],
    data: &mut [u8], input: &[u8], block128: &mut [u8;16]
) {
    // aes
    let aes_cipher1 = Aes128::new(key128.into());
    aes_cipher1.encrypt_block(block128.into());
    aes_cipher1.decrypt_block(block128.into());

    let aes_cipher2 = Aes192Enc::new_from_slice(key192).unwrap();
    aes_cipher2.encrypt_block(block128.into());

    let aes_cipher3 = Aes256Dec::new(key256.into());
    aes_cipher3.decrypt_block(block128.into());

    // des (broken)
    let des_cipher1 = Des::new(key.into()); // $ Alert[rust/weak-cryptographic-algorithm]
    des_cipher1.encrypt_block(data.into());
    des_cipher1.decrypt_block(data.into());

    let des_cipher2 = des::Des::new(key.into()); // $ Alert[rust/weak-cryptographic-algorithm]
    des_cipher2.encrypt_block(data.into());
    des_cipher2.decrypt_block(data.into());

    let des_cipher3 = Des::new_from_slice(key).expect("fail"); // $ Alert[rust/weak-cryptographic-algorithm]
    des_cipher3.encrypt_block(data.into());
    des_cipher3.decrypt_block(data.into());

    let des_cipher4 = Des::new(key.into()); // $ Alert[rust/weak-cryptographic-algorithm]
    des_cipher4.encrypt_block_b2b(input.into(), data.into());
    des_cipher4.decrypt_block_b2b(input.into(), data.into());

    let mut des_cipher5 = Des::new(key.into()); // $ Alert[rust/weak-cryptographic-algorithm]
    des_cipher5.encrypt_block_mut(data.into());
    des_cipher5.decrypt_block_mut(data.into());

    // triple des (broken)
    let tdes_cipher1 = TdesEde2::new(key.into()); // $ Alert[rust/weak-cryptographic-algorithm]
    tdes_cipher1.encrypt_block(data.into());
    tdes_cipher1.decrypt_block(data.into());

    let tdes_cipher2 = TdesEde3::new(key.into()); // $ Alert[rust/weak-cryptographic-algorithm]
    tdes_cipher2.encrypt_block(data.into());
    tdes_cipher2.decrypt_block(data.into());

    let tdes_cipher3 = TdesEee2::new(key.into()); // $ Alert[rust/weak-cryptographic-algorithm]
    tdes_cipher3.encrypt_block(data.into());
    tdes_cipher3.decrypt_block(data.into());

    let tdes_cipher4 = TdesEee3::new_from_slice(key).unwrap(); // $ Alert[rust/weak-cryptographic-algorithm]
    tdes_cipher4.encrypt_block(data.into());
    tdes_cipher4.decrypt_block(data.into());

    // rc2 (broken)
    let rc2_cipher1 = Rc2::new(key.into()); // $ Alert[rust/weak-cryptographic-algorithm]
    rc2_cipher1.encrypt_block(data.into());
    rc2_cipher1.decrypt_block(data.into());

    let rc2_cipher2 = Rc2::new_from_slice(key).expect("fail"); // $ Alert[rust/weak-cryptographic-algorithm]
    rc2_cipher2.encrypt_block(data.into());
    rc2_cipher2.decrypt_block(data.into());

    let rc2_cipher3 = Rc2::new_with_eff_key_len(key, 64); // $ Alert[rust/weak-cryptographic-algorithm]
    rc2_cipher3.encrypt_block(data.into());
    rc2_cipher3.decrypt_block(data.into());

    // rc5 (broken)
    let rc5_cipher1 = RC5_16_16_8::new(key.into()); // $ Alert[rust/weak-cryptographic-algorithm]
    rc5_cipher1.encrypt_block(data.into());
    rc5_cipher1.decrypt_block(data.into());

    let rc5_cipher2 = RC5_32_16_16::new_from_slice(key).unwrap(); // $ Alert[rust/weak-cryptographic-algorithm]
    rc5_cipher2.encrypt_block(data.into());
    rc5_cipher2.decrypt_block(data.into());
}

type MyDesEncryptor = cbc::Encryptor<des::Des>;

fn test_cbc(
    key: &[u8], key128: &[u8;16], iv: &[u8], iv128: &[u8;16],
    input: &[u8], data: &mut [u8]
) {
    let data_len = data.len();

    // aes
    let aes_cipher1 = cbc::Encryptor::<aes::Aes128>::new(key128.into(), iv128.into());
    _ = aes_cipher1.encrypt_padded_mut::<aes::cipher::block_padding::Pkcs7>(data, data_len).unwrap();

    // des (broken)
    let des_cipher1 = cbc::Encryptor::<des::Des>::new(key.into(), iv.into()); // $ Alert[rust/weak-cryptographic-algorithm]
    _ = des_cipher1.encrypt_padded_mut::<des::cipher::block_padding::Pkcs7>(data, data_len).unwrap();

    let des_cipher2 = MyDesEncryptor::new(key.into(), iv.into()); // $ MISSING: Alert[rust/weak-cryptographic-algorithm]
    _ = des_cipher2.encrypt_padded_mut::<des::cipher::block_padding::Pkcs7>(data, data_len).unwrap();

    let des_cipher3 = cbc::Encryptor::<des::Des>::new_from_slices(&key, &iv).unwrap(); // $ Alert[rust/weak-cryptographic-algorithm]
    _ = des_cipher3.encrypt_padded_mut::<des::cipher::block_padding::Pkcs7>(data, data_len).unwrap();

    let des_cipher4 = cbc::Encryptor::<des::Des>::new(key.into(), iv.into()); // $ Alert[rust/weak-cryptographic-algorithm]
    _ = des_cipher4.encrypt_padded_b2b_mut::<des::cipher::block_padding::Pkcs7>(input, data).unwrap();
}
