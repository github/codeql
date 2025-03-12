func getData() {
	// ...

	// GOOD: not sensitive information
	let body = reqwest::get("https://example.com/data").await?.text().await?;

	// BAD: sensitive information sent in cleartext
	let body = reqwest::get(format!("https://example.com/data?password={password}")).await?.text().await?;

	// GOOD: encrypted sensitive information sent
	let encryptedPassword = encrypt(password, encryptionKey);
	let body = reqwest::get(format!("https://example.com/data?password={encryptedPassword}")).await?.text().await?;

	// ...
}
