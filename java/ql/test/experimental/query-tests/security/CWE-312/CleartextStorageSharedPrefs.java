import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import androidx.security.crypto.MasterKey;
import androidx.security.crypto.EncryptedSharedPreferences;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.security.MessageDigest;

/* Android activity that tests saving sensitive information in `SharedPreferences` */
public class CleartextStorageSharedPrefs extends Activity {
	// BAD - save sensitive information in cleartext
	public void testSetSharedPrefs1(Context context, String name, String password) {
		SharedPreferences sharedPrefs = context.getSharedPreferences("user_prefs", Context.MODE_PRIVATE);
		Editor editor = sharedPrefs.edit();
		editor.putString("name", name);
		editor.putString("password", password);
		editor.commit();
	}

	// GOOD - save sensitive information in encrypted format
	public void testSetSharedPrefs2(Context context, String name, String password) throws Exception {
		SharedPreferences sharedPrefs = context.getSharedPreferences("user_prefs", Context.MODE_PRIVATE);
		Editor editor = sharedPrefs.edit();
		editor.putString("name", encrypt(name));
		editor.putString("password", encrypt(password));
		editor.commit();
	}

	private static String encrypt(String cleartext) throws Exception {
		// Use an encryption or hashing algorithm in real world. The demo below just returns its hash.
		MessageDigest digest = MessageDigest.getInstance("SHA-256");
		byte[] hash = digest.digest(cleartext.getBytes(StandardCharsets.UTF_8));
		String encoded = Base64.getEncoder().encodeToString(hash);
		return encoded;
	}

	// GOOD - save sensitive information in encrypted format using separate variables
	public void testSetSharedPrefs3(Context context, String name, String password) throws Exception {
		String encUsername = encrypt(name);
		String encPassword = encrypt(password);
		SharedPreferences sharedPrefs = context.getSharedPreferences("user_prefs", Context.MODE_PRIVATE);
		Editor editor = sharedPrefs.edit();
		editor.putString("name", encUsername);
		editor.putString("password", encPassword);
		editor.commit();
	}


	// GOOD - save sensitive information using the built-in `EncryptedSharedPreferences` class in androidx
	public void testSetSharedPrefs4(Context context, String name, String password) throws Exception {
		MasterKey masterKey = new MasterKey.Builder(context, MasterKey.DEFAULT_MASTER_KEY_ALIAS)
			.setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
			.build();

		SharedPreferences sharedPreferences = EncryptedSharedPreferences.create(
			context,
			"secret_shared_prefs",
			masterKey,
			EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
			EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM);

		// Use the shared preferences and editor as you normally would
		SharedPreferences.Editor editor = sharedPreferences.edit();
		editor.putString("name", name);
		editor.putString("password", password);
		editor.commit();
	}

	// GOOD - save sensitive information using the built-in `EncryptedSharedPreferences` class in androidx
	public void testSetSharedPrefs5(Context context, String name, String password) throws Exception {
		MasterKey masterKey = new MasterKey.Builder(context, MasterKey.DEFAULT_MASTER_KEY_ALIAS)
			.setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
			.build();

		SharedPreferences.Editor editor = EncryptedSharedPreferences.create(
				context,
				"secret_shared_prefs",
				masterKey,
				EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
				EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM)
			.edit();

		// Use the shared preferences and editor as you normally would
		editor.putString("name", name);
		editor.putString("password", password);
		editor.commit();
	}

	// GOOD - save sensitive information using the built-in `EncryptedSharedPreferences` class in androidx
	public void testSetSharedPrefs6(Context context, String name, String password) throws Exception {
		MasterKey masterKey = new MasterKey.Builder(context, MasterKey.DEFAULT_MASTER_KEY_ALIAS)
			.setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
			.build();

		SharedPreferences.Editor editor = EncryptedSharedPreferences.create(
				context,
				"secret_shared_prefs",
				masterKey,
				EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
				EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM)
			.edit()
			.putString("name", name)  // Use the shared preferences and editor as you normally would
			.putString("password", password);
			
		editor.commit();
	}
}
