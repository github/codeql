public class SecureDexLoading extends Application {
	@Override
	public void onCreate() {
		super.onCreate();
		updateChecker();
	}

	private void updateChecker() {
		try {
			File file = new File(getCacheDir() + "/updater.apk");
			if (file.exists() && file.isFile() && file.length() <= 1000) {
				DexClassLoader cl = new DexClassLoader(file.getAbsolutePath(), getCacheDir().getAbsolutePath(), null,
						getClassLoader());
				int version = (int) cl.loadClass("my.package.class").getDeclaredMethod("myMethod").invoke(null);
				if (Build.VERSION.SDK_INT < version) {
					Toast.makeText(this, "Securely loaded Dex!", Toast.LENGTH_LONG).show();
				}
			}
		} catch (Exception e) {
			// ignore
		}
	}
}