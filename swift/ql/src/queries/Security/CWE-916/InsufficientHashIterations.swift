
func encrypt() {
	// ...

	// BAD: Using insufficient (i.e., < 1000) hash iterations keys for encryption
	_ = try PKCS5.PBKDF1(password: getRandomArray(), salt: getRandomArray(), iterations: 900, keyLength: 0)
	_ = try PKCS5.PBKDF2(password: getRandomArray(), salt: getRandomArray(), iterations: 900, keyLength: 0)

	// GOOD: Using sufficient (i.e., >= 1000) hash iterations keys for encryption
	_ = try PKCS5.PBKDF1(password: getRandomArray(), salt: getRandomArray(), iterations: 1100, keyLength: 0)
	_ = try PKCS5.PBKDF2(password: getRandomArray(), salt: getRandomArray(), iterations: 1100, keyLength: 0)

	// ...
}
