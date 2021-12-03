
import android.app.Application;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.os.Bundle;

import dalvik.system.DexClassLoader;
import dalvik.system.DexFile;

public class InsecureDexLoading extends Application {
	@Override
	public void onCreate() {
		super.onCreate();
		updateChecker();
	}

	private void updateChecker() {
		try {
			File file = new File("/sdcard/updater.apk");
			if (file.exists() && file.isFile() && file.length() <= 1000) {
				DexClassLoader cl = new DexClassLoader(file.getAbsolutePath(), getCacheDir().getAbsolutePath(), null,
						getClassLoader());
				int version = (int) cl.loadClass("my.package.class").getDeclaredMethod("myMethod").invoke(null);
				if (Build.VERSION.SDK_INT < version) {
					Toast.makeText(this, "Loaded Dex!", Toast.LENGTH_LONG).show();
				}
			}
		} catch (Exception e) {
			// ignore
		}
	}
}
