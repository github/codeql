fn encrypt(text: String, encryption_key: &aes_gcm::Key<Aes256Gcm>) -> String {
    // encrypt text -> ciphertext
    let cipher = Aes256Gcm::new(&encryption_key);
    let nonce = Aes256Gcm::generate_nonce(&mut OsRng);
    let ciphertext = cipher.encrypt(&nonce, text.as_ref()).unwrap();

    // append (nonce, ciphertext)
    let mut combined = nonce.to_vec();
    combined.extend(ciphertext);

    // encode to base64 string
    BASE64_STANDARD.encode(combined)
}

fn decrypt(data: String, encryption_key: &aes_gcm::Key<Aes256Gcm>) -> String {
    let cipher = Aes256Gcm::new(&encryption_key);

    // decode base64 string
    let decoded = BASE64_STANDARD.decode(data).unwrap();

    // split into (nonce, ciphertext)
    let nonce_size = <Aes256Gcm as AeadCore>::NonceSize::to_usize();
    let (nonce, ciphertext) = decoded.split_at(nonce_size);

    // decrypt ciphertext -> plaintext
    let plaintext = cipher.decrypt(nonce.into(), ciphertext).unwrap();
    String::from_utf8(plaintext).unwrap()
}

...

let encryption_key = Aes256Gcm::generate_key(OsRng);

...

let query = "INSERT INTO PAYMENTDETAILS(ID, CARDNUM) VALUES(?, ?)";
let result = sqlx::query(query)
	.bind(id)
	.bind(encrypt(credit_card_number, &encryption_key)) // GOOD: Encrypted storage of sensitive data in the database
	.execute(pool)
	.await?;
