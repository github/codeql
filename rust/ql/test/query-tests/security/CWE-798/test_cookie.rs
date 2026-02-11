
use cookie::{CookieJar, SignedJar, PrivateJar, Key};

// --- tests ---

fn test_cookie_jar(array_var: &[u8]) {
    let mut jar = CookieJar::new();

    let key_generate = Key::generate(); // good
    _ = jar.signed_mut(&key_generate);
    _ = jar.private_mut(&key_generate);

    let key_var = Key::from(array_var); // good
    _ = jar.signed_mut(&key_var);
    _ = jar.private_mut(&key_var);

    let array1: [u8; 64] = [0; 64]; // $ Alert[rust/hard-coded-cryptographic-value]
    let key1 = Key::from(&array1); // $ Sink
    _ = jar.signed_mut(&key1);

    let array2: [u8; 64] = [0; 64]; // $ Alert[rust/hard-coded-cryptographic-value]
    let key2 = Key::from(&array2); // $ Sink
    _ = jar.private_mut(&key2);
}

fn test_biscotti_crypto(array_var: &[u8]) {
    let mut config1 = biscotti::ProcessorConfig::default();
    let crypto_rules1 = biscotti::config::CryptoRule {
        cookie_names: vec!["name".to_string()],
        algorithm: biscotti::config::CryptoAlgorithm::Signing,
        key: biscotti::Key::generate(), // good
        fallbacks: vec![],
    };
    config1.crypto_rules.push(crypto_rules1);
    let processor1: biscotti::Processor = config1.into();

    let mut config2 = biscotti::ProcessorConfig::default();
    let array2 = Vec::from([0u8; 64]); // $ Alert[rust/hard-coded-cryptographic-value]
    let crypto_rules2 = biscotti::config::CryptoRule {
        cookie_names: vec!["name".to_string()],
        algorithm: biscotti::config::CryptoAlgorithm::Signing,
        key: biscotti::Key::from(array2), // $ Sink
        fallbacks: vec![],
    };
    config2.crypto_rules.push(crypto_rules2);
    let processor2: biscotti::Processor = config2.into();

    let mut config3 = biscotti::ProcessorConfig::default();
    let array3 = vec![0u8; 64]; // $ Alert[rust/hard-coded-cryptographic-value]
    let crypto_rules3 = biscotti::config::CryptoRule {
        cookie_names: vec!["name".to_string()],
        algorithm: biscotti::config::CryptoAlgorithm::Signing,
        key: biscotti::Key::from(array3), // $ Sink
        fallbacks: vec![],
    };
    config3.crypto_rules.push(crypto_rules3);
    let processor3: biscotti::Processor = config3.into();
}
