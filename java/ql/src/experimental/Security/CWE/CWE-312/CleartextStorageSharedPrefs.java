public void testSetSharedPrefs(Context context, String name, String password)
{
	{
		// BAD - save sensitive information in cleartext
		SharedPreferences sharedPrefs = context.getSharedPreferences("user_prefs", Context.MODE_PRIVATE);
		Editor editor = sharedPrefs.edit();
		editor.putString("name", name);
		editor.putString("password", password);
		editor.commit();
	}

	{
		// GOOD - save sensitive information in encrypted format
		SharedPreferences sharedPrefs = context.getSharedPreferences("user_prefs", Context.MODE_PRIVATE);
		Editor editor = sharedPrefs.edit();
		editor.putString("name", encrypt(name));
		editor.putString("password", encrypt(password));
		editor.commit();
	}

	{
		// GOOD - save sensitive information using the built-in `EncryptedSharedPreferences` class in androidx.
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
