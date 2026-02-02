
// --- tests ---

fn encrypt_with(plaintext: &str, key: &[u8;16], iv: &[u8;16]) {
    // ...
}

fn encrypt2(plaintext: &str, crypto_key: &[u8;16], iv_bytes: &[u8;16]) {
    // ...
}

fn database_op(text: &str, primary_key: &str, pivot: &str) {
    // note: this one has nothing to do with encryption, but has
    // `key` and `iv` contained within the parameter names.
}

struct MyCryptor {
}

impl MyCryptor {
    fn new(password: &str) -> MyCryptor {
        MyCryptor { }
    }

    fn set_nonce(&self, nonce: &[u8;16]) {
        // ...
    }

    fn encrypt(&self, plaintext: &str, salt: &[u8;16]) {
        // ...
    }

    fn set_salt_u64(&self, salt: u64) {
        // ...
    }
}

fn test(var_string: &str, var_data: &[u8;16], var_u64: u64) {
    encrypt_with("plaintext", var_data, var_data);

    let const_key: &[u8;16] = &[0u8;16]; // $ MISSING: Alert[rust/hard-coded-cryptographic-value]
    encrypt_with("plaintext", const_key, var_data); // $ MISSING: Sink

    let const_iv: &[u8;16] = &[0u8;16]; // $ Alert[rust/hard-coded-cryptographic-value]
    encrypt_with("plaintext", var_data, const_iv); // $ Sink

    encrypt2("plaintext", var_data, var_data);

    let const_key2: &[u8;16] = &[1u8;16]; // $ MISSING: Alert[rust/hard-coded-cryptographic-value]
    encrypt2("plaintext", const_key2, var_data); // $ MISSING: Sink

    let const_iv: &[u8;16] = &[1u8;16]; // $ MISSING: Alert[rust/hard-coded-cryptographic-value]
    encrypt2("plaintext", var_data, const_iv); // $ MISSING: Sink

    let const_key_str = "primary_key";
    let const_pivot_str = "pivot";
    database_op("text", const_key_str, const_pivot_str);

    let mc1 = MyCryptor::new(var_string);
    mc1.set_nonce(var_data);
    mc1.encrypt("plaintext", var_data);

    let mc2 = MyCryptor::new("secret"); // $ Alert[rust/hard-coded-cryptographic-value]
    mc2.set_nonce(&[0u8;16]); // $ Alert[rust/hard-coded-cryptographic-value]
    mc2.encrypt("plaintext", &[0u8;16]); // $ Alert[rust/hard-coded-cryptographic-value]

    mc2.set_salt_u64(0); // $ Alert[rust/hard-coded-cryptographic-value]
    mc2.set_salt_u64(var_u64);
    mc2.set_salt_u64(var_u64 + 1); // $ SPURIOUS: Alert[rust/hard-coded-cryptographic-value]
    mc2.set_salt_u64((var_u64 << 32) ^ (var_u64  & 0xFFFFFFFF)); // $ SPURIOUS: Alert[rust/hard-coded-cryptographic-value]
}
