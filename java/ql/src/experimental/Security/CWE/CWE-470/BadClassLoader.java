package poc.sample.classloader;

import android.app.Application;
import android.content.pm.PackageInfo;
import android.content.Context;
import android.util.Log;

public class BadClassLoader extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        for (PackageInfo p : getPackageManager().getInstalledPackages(0)) {
            try {
                if (p.packageName.startsWith("some.package.")) {
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
