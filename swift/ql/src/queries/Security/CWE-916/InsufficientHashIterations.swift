
func encrypt() {
	// ...

	// BAD: Using insufficient (that is, < 120,000) hash iterations keys for encryption
	_ = try PKCS5.PBKDF1(password: getRandomArray(), salt: getRandomArray(), iterations: 90000, keyLength: 0)
	_ = try PKCS5.PBKDF2(password: getRandomArray(), salt: getRandomArray(), iterations: 90000, keyLength: 0)

	// GOOD: Using sufficient (that is, >= 120,000) hash iterations keys for encryption
	_ = try PKCS5.PBKDF1(password: getRandomArray(), salt: getRandomArray(), iterations: 120120, keyLength: 0)
	_ = try PKCS5.PBKDF2(password: getRandomArray(), salt: getRandomArray(), iterations: 120120, keyLength: 0)

	// ...
}
