public void testSetSharedPrefs(Context context, String name, String password)
{
	{
		// BAD - sensitive information saved in cleartext.
		SharedPreferences sharedPrefs = context.getSharedPreferences("user_prefs", Context.MODE_PRIVATE);
		Editor editor = sharedPrefs.edit();
		editor.putString("name", name);
		editor.putString("password", password);
		editor.commit();
	}

	{
		// GOOD - save sensitive information encrypted with a custom method.
		SharedPreferences sharedPrefs = context.getSharedPreferences("user_prefs", Context.MODE_PRIVATE);
		Editor editor = sharedPrefs.edit();
		editor.putString("name", encrypt(name));
		editor.putString("password", encrypt(password));
		editor.commit();
	}

	{
		// GOOD - sensitive information saved using the built-in `EncryptedSharedPreferences` class in androidx.
		MasterKey masterKey = new MasterKey.Builder(context, MasterKey.DEFAULT_MASTER_KEY_ALIAS)
			.setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
			.build();

		SharedPreferences sharedPreferences = EncryptedSharedPreferences.create(
			context,
			"secret_shared_prefs",
			masterKey,
			EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
			EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM);

		SharedPreferences.Editor editor = sharedPreferences.edit();
		editor.putString("name", name);
		editor.putString("password", password);
		editor.commit();
	}
}

private static String encrypt(String cleartext) throws Exception {
	// Use an encryption or hashing algorithm in real world. The demo below just returns its
	// hash.
	MessageDigest digest = MessageDigest.getInstance("SHA-256");
	byte[] hash = digest.digest(cleartext.getBytes(StandardCharsets.UTF_8));
	String encoded = Base64.getEncoder().encodeToString(hash);
	return encoded;
}
