import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import androidx.security.crypto.MasterKey;
import androidx.security.crypto.EncryptedSharedPreferences;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.security.MessageDigest;

public class CleartextStorageSharedPrefsTest extends Activity {
	public void testSetSharedPrefs1(Context context, String name, String password) {
		SharedPreferences sharedPrefs =
				context.getSharedPreferences("user_prefs", Context.MODE_PRIVATE);
		Editor editor = sharedPrefs.edit();
		editor.putString("name", name); // Safe
		editor.putString("password", password); // $ hasCleartextStorageSharedPrefs
		editor.commit();
	}

	public void testSetSharedPrefs2(Context context, String name, String password)
			throws Exception {
		SharedPreferences sharedPrefs =
				context.getSharedPreferences("user_prefs", Context.MODE_PRIVATE);
		Editor editor = sharedPrefs.edit();
		editor.putString("name", encrypt(name)); // Safe
		editor.putString("password", encrypt(password)); // Safe
		editor.commit();
	}

	private static String encrypt(String cleartext) throws Exception {
		MessageDigest digest = MessageDigest.getInstance("SHA-256");
		byte[] hash = digest.digest(cleartext.getBytes(StandardCharsets.UTF_8));
		String encoded = Base64.getEncoder().encodeToString(hash);
		return encoded;
	}

	public void testSetSharedPrefs3(Context context, String name, String password)
			throws Exception {
		String encUsername = encrypt(name);
		String encPassword = encrypt(password);
		SharedPreferences sharedPrefs =
				context.getSharedPreferences("user_prefs", Context.MODE_PRIVATE);
		Editor editor = sharedPrefs.edit();
		editor.putString("name", encUsername); // Safe
		editor.putString("password", encPassword); // Safe
		editor.commit();
	}

	public void testSetSharedPrefs4(Context context, String name, String password)
			throws Exception {
		MasterKey masterKey = new MasterKey.Builder(context, MasterKey.DEFAULT_MASTER_KEY_ALIAS)
				.setKeyScheme(MasterKey.KeyScheme.AES256_GCM).build();

		SharedPreferences sharedPreferences =
				EncryptedSharedPreferences.create(context, "secret_shared_prefs", masterKey,
						EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
						EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM);

		SharedPreferences.Editor editor = sharedPreferences.edit();
		editor.putString("name", name); // Safe
		editor.putString("password", password); // Safe
		editor.commit();
	}

	public void testSetSharedPrefs5(Context context, String name, String password)
			throws Exception {
		MasterKey masterKey = new MasterKey.Builder(context, MasterKey.DEFAULT_MASTER_KEY_ALIAS)
				.setKeyScheme(MasterKey.KeyScheme.AES256_GCM).build();

		SharedPreferences.Editor editor =
				EncryptedSharedPreferences
						.create(context, "secret_shared_prefs", masterKey,
								EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
								EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM)
						.edit();

		editor.putString("name", name); // Safe
		editor.putString("password", password); // Safe
		editor.commit();
	}

	public void testSetSharedPrefs6(Context context, String name, String password)
			throws Exception {
		MasterKey masterKey = new MasterKey.Builder(context, MasterKey.DEFAULT_MASTER_KEY_ALIAS)
				.setKeyScheme(MasterKey.KeyScheme.AES256_GCM).build();

		SharedPreferences.Editor editor = EncryptedSharedPreferences
				.create(context, "secret_shared_prefs", masterKey,
						EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
						EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM)
				.edit().putString("name", name) // Safe
				.putString("password", password); // Safe

		editor.commit();
	}

	public void testSetSharedPrefs7(Context context, String name, String password) {
		SharedPreferences sharedPrefs =
				context.getSharedPreferences("user_prefs", Context.MODE_PRIVATE);
		sharedPrefs.edit().putString("name", name).apply(); // Safe
		sharedPrefs.edit().putString("password", password).apply(); // $hasCleartextStorageSharedPrefs
	}
}
