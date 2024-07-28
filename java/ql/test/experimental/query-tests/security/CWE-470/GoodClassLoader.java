package poc.sample.classloader;

import android.app.Application;
import android.content.pm.PackageInfo;
import android.content.Context;
import android.content.pm.PackageManager;
import android.util.Log;

public class GoodClassLoader extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        PackageManager pm = getPackageManager();
        for (PackageInfo p : pm.getInstalledPackages(0)) {
            try {
                if (p.packageName.startsWith("some.package.") &&
                        (pm.checkSignatures(p.packageName, getApplicationContext().getPackageName()) == PackageManager.SIGNATURE_MATCH)
                ) {
                    Context appContext = createPackageContext(p.packageName,
                            CONTEXT_INCLUDE_CODE | CONTEXT_IGNORE_SECURITY);
                    ClassLoader classLoader = appContext.getClassLoader();
                    Object result = classLoader.loadClass("some.package.SomeClass")
                            .getMethod("someMethod")
                            .invoke(null);
                }
            } catch (Exception e) {
                Log.e("Class loading failed", e.toString());
            }
        }
    }
}
