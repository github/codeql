import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import androidx.security.crypto.MasterKey;
import androidx.security.crypto.EncryptedSharedPreferences;

/** Android activity that tests saving sensitive information in `SharedPreferences`  */
public class ClearTextStorageSharedPrefs extends Activity {
	// BAD - save sensitive information in cleartext
	public void testSetSharedPrefs1(Context context, String name, String password) {
		SharedPreferences sharedPrefs = context.getSharedPreferences("user_prefs", Context.MODE_PRIVATE);
		Editor editor = sharedPrefs.edit();
		editor.putString("name", name);
		editor.putString("password", password);
		editor.commit();
	}

	// GOOD - save sensitive information in encrypted format
	public void testSetSharedPrefs2(Context context, String name, String password) {
		SharedPreferences sharedPrefs = context.getSharedPreferences("user_prefs", Context.MODE_PRIVATE);
		Editor editor = sharedPrefs.edit();
		editor.putString("name", encrypt(name));
		editor.putString("password", encrypt(password));
		editor.commit();
	}

    private static String encrypt(String cleartext) {
        //Use an encryption or hashing algorithm in real world. The demo below just returns an arbitrary value.
        String cipher = "whatever_encrypted";
        return cipher;
    }

	// GOOD - save sensitive information using the built-in `EncryptedSharedPreferences` class in androidx.
	public void testSetSharedPrefs3(Context context, String name, String password) {
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

}