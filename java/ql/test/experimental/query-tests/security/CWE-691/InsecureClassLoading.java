
import android.app.Application;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;

public class InsecureClassLoading extends Application {
  @Override
  public void onCreate() {
    super.onCreate();
    invokePlugins();
  }

  private void invokePlugins() {
    PackageManager pm;
    for (PackageInfo info : pm.getInstalledPackages(0)) {      
      String packageName = info.packageName;

      if (packageName.startsWith("somename.plugin.")) {
        try {
          ContextWrapper cw = new ContextWrapper();
          Context packageContext = cw.createPackageContext(packageName, 3);
          packageContext = cw.createPackageContext("test.test", 0);
          packageContext = cw.createPackageContext("test.test", 3);
          packageContext = cw.createPackageContext("test.test", Context.CONTEXT_INCLUDE_CODE | Context.CONTEXT_IGNORE_SECURITY);

          packageName = "com";
          packageName += ".test.package";
          packageContext = cw.createPackageContext(packageName, Context.CONTEXT_INCLUDE_CODE | Context.CONTEXT_IGNORE_SECURITY);
          packageContext = cw.createPackageContext(packageName, 0);
          packageContext = cw.createPackageContext(packageName, 3);

          packageName = "com.test";
          packageName += ".package";
          packageContext = cw.createPackageContext(packageName, Context.CONTEXT_INCLUDE_CODE | Context.CONTEXT_IGNORE_SECURITY);
          packageContext = cw.createPackageContext(packageName, 0);
          packageContext = cw.createPackageContext(packageName, 3);

          int flags = Context.CONTEXT_INCLUDE_CODE | Context.CONTEXT_IGNORE_SECURITY;
          packageContext = cw.createPackageContext(packageName, flags);

          packageContext.getClassLoader().loadClass("somename.pluginLoader").getMethod("load", Context.class)
              .invoke(null, this);
        } catch (Exception e) {
          throw new RuntimeException(e);
        }
      }
    }
  }
}
