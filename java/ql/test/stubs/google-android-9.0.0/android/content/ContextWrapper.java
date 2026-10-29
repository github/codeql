/*
 * Copyright (C) 2006 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package android.content;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.concurrent.Executor;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.res.AssetManager;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.database.DatabaseErrorHandler;
import android.database.sqlite.SQLiteDatabase;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.UserHandle;
import android.view.Display;

/**
 * Proxying implementation of Context that simply delegates all of its calls to
 * another Context.  Can be subclassed to modify behavior without changing
 * the original Context.
 */
public class ContextWrapper extends Context {
    public ContextWrapper() {}

    public Context getBaseContext() {
        return null;
    }

    @Override
    public Executor getMainExecutor() {
        return null;
    }

    public ContextWrapper(Context base) {
    }

    /** @hide **/
    public void startActivityForResult(
            String who, Intent intent, int requestCode, Bundle options) {
    }

    /** @hide **/
    public boolean canStartActivityForResult() {
        return false;
    }

    @Override public ApplicationInfo getApplicationInfo() { return null; }
    @Override public AssetManager getAssets() { return null; }
    @Override public ClassLoader getClassLoader() { return null; }
    @Override public ComponentName startForegroundService(Intent p0) { return null; }
    @Override public ComponentName startService(Intent p0) { return null; }
    @Override public ComponentName startServiceAsUser(Intent p0, UserHandle p1) { return null; }
    @Override public ContentResolver getContentResolver() { return null; }
    @Override public Context createConfigurationContext(Configuration p0) { return null; }
    @Override public Context createContextForSplit(String p0) { return null; }
    @Override public Context createDeviceProtectedStorageContext() { return null; }
    @Override public Context createDisplayContext(Display p0) { return null; }
    @Override public Context createPackageContext(String p0, int p1) { return null; }
    @Override public Context getApplicationContext() { return null; }
    @Override public Drawable getWallpaper() { return null; }
    @Override public Drawable peekWallpaper() { return null; }
    @Override public File getCacheDir() { return null; }
    @Override public File getCodeCacheDir() { return null; }
    @Override public File getDataDir() { return null; }
    @Override public File getDatabasePath(String p0) { return null; }
    @Override public File getDir(String p0, int p1) { return null; }
    @Override public File getExternalCacheDir() { return null; }
    @Override public File getExternalFilesDir(String p0) { return null; }
    @Override public File getFileStreamPath(String p0) { return null; }
    @Override public File getFilesDir() { return null; }
    @Override public File getNoBackupFilesDir() { return null; }
    @Override public File getObbDir() { return null; }
    @Override public FileInputStream openFileInput(String p0) { return null; }
    @Override public FileOutputStream openFileOutput(String p0, int p1) { return null; }
    @Override public File[] getExternalCacheDirs() { return null; }
    @Override public File[] getExternalFilesDirs(String p0) { return null; }
    @Override public File[] getExternalMediaDirs() { return null; }
    @Override public File[] getObbDirs() { return null; }
    @Override public Intent registerReceiver(BroadcastReceiver p0, IntentFilter p1) { return null; }
    @Override public Intent registerReceiver(BroadcastReceiver p0, IntentFilter p1, String p2, Handler p3) { return null; }
    @Override public Intent registerReceiver(BroadcastReceiver p0, IntentFilter p1, String p2, Handler p3, int p4) { return null; }
    @Override public Intent registerReceiver(BroadcastReceiver p0, IntentFilter p1, int p2) { return null; }
    @Override public Looper getMainLooper() { return null; }
    @Override public Object getSystemService(String p0) { return null; }
    @Override public PackageManager getPackageManager() { return null; }
    @Override public Resources getResources() { return null; }
    @Override public Resources.Theme getTheme() { return null; }
    @Override public SQLiteDatabase openOrCreateDatabase(String p0, int p1, SQLiteDatabase.CursorFactory p2) { return null; }
    @Override public SQLiteDatabase openOrCreateDatabase(String p0, int p1, SQLiteDatabase.CursorFactory p2, DatabaseErrorHandler p3) { return null; }
    @Override public SharedPreferences getSharedPreferences(String p0, int p1) { return null; }
    @Override public String getPackageCodePath() { return null; }
    @Override public String getPackageName() { return null; }
    @Override public String getPackageResourcePath() { return null; }
    @Override public String getSystemServiceName(Class<? extends Object> p0) { return null; }
    @Override public String[] databaseList() { return null; }
    @Override public String[] fileList() { return null; }
    @Override public boolean bindService(Intent p0, ServiceConnection p1, int p2) { return false; }
    @Override public boolean bindServiceAsUser(Intent p0, ServiceConnection p1, int p2, UserHandle p3) { return false; }
    @Override public boolean deleteDatabase(String p0) { return false; }
    @Override public boolean deleteFile(String p0) { return false; }
    @Override public boolean deleteSharedPreferences(String p0) { return false; }
    @Override public boolean isDeviceProtectedStorage() { return false; }
    @Override public boolean moveDatabaseFrom(Context p0, String p1) { return false; }
    @Override public boolean moveSharedPreferencesFrom(Context p0, String p1) { return false; }
    @Override public boolean startInstrumentation(ComponentName p0, String p1, Bundle p2) { return false; }
    @Override public boolean stopService(Intent p0) { return false; }
    @Override public int checkCallingOrSelfPermission(String p0) { return 0; }
    @Override public int checkCallingOrSelfUriPermission(Uri p0, int p1) { return 0; }
    @Override public int checkCallingPermission(String p0) { return 0; }
    @Override public int checkCallingUriPermission(Uri p0, int p1) { return 0; }
    @Override public int checkPermission(String p0, int p1, int p2) { return 0; }
    @Override public int checkSelfPermission(String p0) { return 0; }
    @Override public int checkUriPermission(Uri p0, String p1, String p2, int p3, int p4, int p5) { return 0; }
    @Override public int checkUriPermission(Uri p0, int p1, int p2, int p3) { return 0; }
    @Override public int getWallpaperDesiredMinimumHeight() { return 0; }
    @Override public int getWallpaperDesiredMinimumWidth() { return 0; }
    @Override public void clearWallpaper() { }
    @Override public void enforceCallingOrSelfPermission(String p0, String p1) { }
    @Override public void enforceCallingOrSelfUriPermission(Uri p0, int p1, String p2) { }
    @Override public void enforceCallingPermission(String p0, String p1) { }
    @Override public void enforceCallingUriPermission(Uri p0, int p1, String p2) { }
    @Override public void enforcePermission(String p0, int p1, int p2, String p3) { }
    @Override public void enforceUriPermission(Uri p0, String p1, String p2, int p3, int p4, int p5, String p6) { }
    @Override public void enforceUriPermission(Uri p0, int p1, int p2, int p3, String p4) { }
    @Override public void grantUriPermission(String p0, Uri p1, int p2) { }
    @Override public void removeStickyBroadcast(Intent p0) { }
    @Override public void removeStickyBroadcastAsUser(Intent p0, UserHandle p1) { }
    @Override public void revokeUriPermission(String p0, Uri p1, int p2) { }
    @Override public void revokeUriPermission(Uri p0, int p1) { }
    @Override public void sendBroadcast(Intent p0) { }
    @Override public void sendBroadcast(Intent p0, String p1) { }
    @Override public void sendBroadcastAsUser(Intent p0, UserHandle p1) { }
    @Override public void sendBroadcastAsUser(Intent p0, UserHandle p1, String p2) { }
    // Slight cheat: this is an Android 11 function which shouldn't really be present in this Android 9 stub.
    @Override public void sendBroadcastWithMultiplePermissions(Intent p1, String[] p2) { }
    @Override public void sendOrderedBroadcast(Intent p0, String p1) { }
    @Override public void sendOrderedBroadcast(Intent p0, String p1, BroadcastReceiver p2, Handler p3, int p4, String p5, Bundle p6) { }
    @Override public void sendOrderedBroadcastAsUser(Intent p0, UserHandle p1, String p2, BroadcastReceiver p3, Handler p4, int p5, String p6, Bundle p7) { }
    @Override public void sendStickyBroadcast(Intent p0) { }
    @Override public void sendStickyBroadcastAsUser(Intent p0, UserHandle p1) { }
    @Override public void sendStickyOrderedBroadcast(Intent p0, BroadcastReceiver p1, Handler p2, int p3, String p4, Bundle p5) { }
    @Override public void sendStickyOrderedBroadcastAsUser(Intent p0, UserHandle p1, BroadcastReceiver p2, Handler p3, int p4, String p5, Bundle p6) { }
    @Override public void setTheme(int p0) { }
    @Override public void setWallpaper(Bitmap p0) { }
    @Override public void setWallpaper(InputStream p0) { }
    @Override public void startActivities(Intent[] p0) { }
    @Override public void startActivities(Intent[] p0, Bundle p1) { }
    @Override public void startActivity(Intent p0) { }
    @Override public void startActivity(Intent p0, Bundle p1) { }
    @Override public void startActivityAsUser(Intent p0, UserHandle p1) { }
    @Override public void startIntentSender(IntentSender p0, Intent p1, int p2, int p3, int p4) { }
    @Override public void startIntentSender(IntentSender p0, Intent p1, int p2, int p3, int p4, Bundle p5) { }
    @Override public void unbindService(ServiceConnection p0) { }
    @Override public void unregisterReceiver(BroadcastReceiver p0) { }
}
