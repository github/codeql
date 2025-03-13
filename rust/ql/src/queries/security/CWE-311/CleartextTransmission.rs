func getData() {
	// ...

	// GOOD: not sensitive information
	let body = reqwest::get("https://example.com/song/{faveSong}").await?.text().await?;

	// BAD: sensitive information sent in cleartext in the URL
	let body = reqwest::get(format!("https://example.com/card/{creditCardNo}")).await?.text().await?;

	// GOOD: encrypted sensitive information sent in the URL
	let encryptedPassword = encrypt(password, encryptionKey);
	let body = reqwest::get(format!("https://example.com/card/{creditCardNo}")).await?.text().await?;

	// ...
}
