import android.app.Activity
import android.content.Context
import android.content.SharedPreferences

class CleartextStorageSharedPrefsTestKt : Activity() {
    fun testSetSharedPrefs1(context: Context, name: String, password: String) {
		val sharedPrefs = context.getSharedPreferences("user_prefs", Context.MODE_PRIVATE);
		sharedPrefs.edit().putString("name", name).apply(); // Safe
		sharedPrefs.edit().putString("password", password).apply(); // $ hasCleartextStorageSharedPrefs
	}
}
