
import android.app.Application;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.os.Bundle;

public class InsecureClassLoading extends Application {
  @Override
  public void onCreate() {
    super.onCreate();
    invokePlugins();
  }

  private void invokePlugins() {
    // An attacker may install a package with a name matching a trusted package's
    // name, this is bad.
    for (PackageInfo info : getPackageManager().getInstalledPackages(0)) {
      String packageName = info.packageName;
      Bundle meta = info.applicationInfo.metaData;
      if (packageName.startsWith("somename.plugin.")) {
        try {
          Context packageContext = createPackageContext(packageName, CONTEXT_INCLUDE_CODE | CONTEXT_IGNORE_SECURITY);
          packageContext.getClassLoader().loadClass("somename.pluginLoader").getMethod("load", Context.class)
              .invoke(null, this);
        } catch (Exception e) {
          throw new RuntimeException(e);
        }
      }
    }
  }
}
