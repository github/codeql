
func hash() {
	// ...

	// BAD: Using insufficient (that is, < 120,000) iterations for password hashing
	_ = try PKCS5.PBKDF1(password: getRandomArray(), salt: getRandomArray(), iterations: 90000, keyLength: 0)
	_ = try PKCS5.PBKDF2(password: getRandomArray(), salt: getRandomArray(), iterations: 90000, keyLength: 0)

	// GOOD: Using sufficient (that is, >= 120,000) iterations for password hashing
	_ = try PKCS5.PBKDF1(password: getRandomArray(), salt: getRandomArray(), iterations: 120120, keyLength: 0)
	_ = try PKCS5.PBKDF2(password: getRandomArray(), salt: getRandomArray(), iterations: 310000, keyLength: 0)

	// ...
}
