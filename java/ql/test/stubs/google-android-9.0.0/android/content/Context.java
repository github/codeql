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
import android.os.Bundle;

/**
 * Interface to global information about an application environment. This is an
 * abstract class whose implementation is provided by the Android system. It
 * allows access to application-specific resources and classes, as well as
 * up-calls for application-level operations such as launching activities,
 * broadcasting and receiving intents, etc.
 */
public abstract class Context {
    /**
     * Return the context of the single, global Application object of the current
     * process. This generally should only be used if you need a Context whose
     * lifecycle is separate from the current context, that is tied to the lifetime
     * of the process rather than the current component.
     *
     * <p>
     * Consider for example how this interacts with
     * {@link #registerReceiver(BroadcastReceiver, IntentFilter)}:
     * <ul>
     * <li>
     * <p>
     * If used from an Activity context, the receiver is being registered within
     * that activity. This means that you are expected to unregister before the
     * activity is done being destroyed; in fact if you do not do so, the framework
     * will clean up your leaked registration as it removes the activity and log an
     * error. Thus, if you use the Activity context to register a receiver that is
     * static (global to the process, not associated with an Activity instance) then
     * that registration will be removed on you at whatever point the activity you
     * used is destroyed.
     * <li>
     * <p>
     * If used from the Context returned here, the receiver is being registered with
     * the global state associated with your application. Thus it will never be
     * unregistered for you. This is necessary if the receiver is associated with
     * static data, not a particular component. However using the ApplicationContext
     * elsewhere can easily lead to serious leaks if you forget to unregister,
     * unbind, etc.
     * </ul>
     */
    public abstract Context getApplicationContext();

    /**
     * Returns the absolute path on the filesystem where a file created with
     * {@link #openFileOutput} is stored.
     * <p>
     * The returned path may change over time if the calling app is moved to an
     * adopted storage device, so only relative paths should be persisted.
     *
     * @param name The name of the file for which you would like to get its path.
     *
     * @return An absolute path to the given file.
     *
     * @see #openFileOutput
     * @see #getFilesDir
     * @see #getDir
     */
    public abstract File getFileStreamPath(String name);

    /**
     * Returns the absolute path on the filesystem where a file created with
     * {@link #getSharedPreferences(String, int)} is stored.
     * <p>
     * The returned path may change over time if the calling app is moved to an
     * adopted storage device, so only relative paths should be persisted.
     *
     * @param name The name of the shared preferences for which you would like to
     *             get a path.
     * @return An absolute path to the given file.
     * @see #getSharedPreferences(String, int)
     * @removed
     */
    public abstract File getSharedPreferencesPath(String name);

    /**
     * Returns the absolute path to the directory on the filesystem where all
     * private files belonging to this app are stored. Apps should not use this path
     * directly; they should instead use {@link #getFilesDir()},
     * {@link #getCacheDir()}, {@link #getDir(String, int)}, or other storage APIs
     * on this class.
     * <p>
     * The returned path may change over time if the calling app is moved to an
     * adopted storage device, so only relative paths should be persisted.
     * <p>
     * No additional permissions are required for the calling app to read or write
     * files under the returned path.
     *
     * @see ApplicationInfo#dataDir
     */
    public abstract File getDataDir();

    /**
     * Returns the absolute path to the directory on the filesystem where files
     * created with {@link #openFileOutput} are stored.
     * <p>
     * The returned path may change over time if the calling app is moved to an
     * adopted storage device, so only relative paths should be persisted.
     * <p>
     * No additional permissions are required for the calling app to read or write
     * files under the returned path.
     *
     * @return The path of the directory holding application files.
     * @see #openFileOutput
     * @see #getFileStreamPath
     * @see #getDir
     */
    public abstract File getFilesDir();

    /**
     * Returns the absolute path to the directory on the filesystem similar to
     * {@link #getFilesDir()}. The difference is that files placed under this
     * directory will be excluded from automatic backup to remote storage. See
     * {@link android.app.backup.BackupAgent BackupAgent} for a full discussion of
     * the automatic backup mechanism in Android.
     * <p>
     * The returned path may change over time if the calling app is moved to an
     * adopted storage device, so only relative paths should be persisted.
     * <p>
     * No additional permissions are required for the calling app to read or write
     * files under the returned path.
     *
     * @return The path of the directory holding application files that will not be
     *         automatically backed up to remote storage.
     * @see #openFileOutput
     * @see #getFileStreamPath
     * @see #getDir
     * @see android.app.backup.BackupAgent
     */
    public abstract File getNoBackupFilesDir();

    /**
     * Returns the absolute path to the directory on the primary shared/external
     * storage device where the application can place persistent files it owns.
     * These files are internal to the applications, and not typically visible to
     * the user as media.
     * <p>
     * This is like {@link #getFilesDir()} in that these files will be deleted when
     * the application is uninstalled, however there are some important differences:
     * <ul>
     * <li>Shared storage may not always be available, since removable media can be
     * ejected by the user. Media state can be checked using
     * {@link Environment#getExternalStorageState(File)}.
     * <li>There is no security enforced with these files. For example, any
     * application holding
     * {@link android.Manifest.permission#WRITE_EXTERNAL_STORAGE} can write to these
     * files.
     * </ul>
     * <p>
     * If a shared storage device is emulated (as determined by
     * {@link Environment#isExternalStorageEmulated(File)}), it's contents are
     * backed by a private user data partition, which means there is little benefit
     * to storing data here instead of the private directories returned by
     * {@link #getFilesDir()}, etc.
     * <p>
     * Starting in {@link android.os.Build.VERSION_CODES#KITKAT}, no permissions are
     * required to read or write to the returned path; it's always accessible to the
     * calling app. This only applies to paths generated for package name of the
     * calling application. To access paths belonging to other packages,
     * {@link android.Manifest.permission#WRITE_EXTERNAL_STORAGE} and/or
     * {@link android.Manifest.permission#READ_EXTERNAL_STORAGE} are required.
     * <p>
     * On devices with multiple users (as described by {@link UserManager}), each
     * user has their own isolated shared storage. Applications only have access to
     * the shared storage for the user they're running as.
     * <p>
     * The returned path may change over time if different shared storage media is
     * inserted, so only relative paths should be persisted.
     * <p>
     * Here is an example of typical code to manipulate a file in an application's
     * shared storage:
     * </p>
     * {@sample development/samples/ApiDemos/src/com/example/android/apis/content/ExternalStorage.java
     * private_file}
     * <p>
     * If you supply a non-null <var>type</var> to this function, the returned file
     * will be a path to a sub-directory of the given type. Though these files are
     * not automatically scanned by the media scanner, you can explicitly add them
     * to the media database with
     * {@link android.media.MediaScannerConnection#scanFile(Context, String[], String[], android.media.MediaScannerConnection.OnScanCompletedListener)
     * MediaScannerConnection.scanFile}. Note that this is not the same as
     * {@link android.os.Environment#getExternalStoragePublicDirectory
     * Environment.getExternalStoragePublicDirectory()}, which provides directories
     * of media shared by all applications. The directories returned here are owned
     * by the application, and their contents will be removed when the application
     * is uninstalled. Unlike
     * {@link android.os.Environment#getExternalStoragePublicDirectory
     * Environment.getExternalStoragePublicDirectory()}, the directory returned here
     * will be automatically created for you.
     * <p>
     * Here is an example of typical code to manipulate a picture in an
     * application's shared storage and add it to the media database:
     * </p>
     * {@sample development/samples/ApiDemos/src/com/example/android/apis/content/ExternalStorage.java
     * private_picture}
     *
     * @param type The type of files directory to return. May be {@code null} for
     *             the root of the files directory or one of the following constants
     *             for a subdirectory:
     *             {@link android.os.Environment#DIRECTORY_MUSIC},
     *             {@link android.os.Environment#DIRECTORY_PODCASTS},
     *             {@link android.os.Environment#DIRECTORY_RINGTONES},
     *             {@link android.os.Environment#DIRECTORY_ALARMS},
     *             {@link android.os.Environment#DIRECTORY_NOTIFICATIONS},
     *             {@link android.os.Environment#DIRECTORY_PICTURES}, or
     *             {@link android.os.Environment#DIRECTORY_MOVIES}.
     * @return the absolute path to application-specific directory. May return
     *         {@code null} if shared storage is not currently available.
     * @see #getFilesDir
     * @see #getExternalFilesDirs(String)
     * @see Environment#getExternalStorageState(File)
     * @see Environment#isExternalStorageEmulated(File)
     * @see Environment#isExternalStorageRemovable(File)
     */
    public abstract File getExternalFilesDir(String type);

    /**
     * Returns absolute paths to application-specific directories on all
     * shared/external storage devices where the application can place persistent
     * files it owns. These files are internal to the application, and not typically
     * visible to the user as media.
     * <p>
     * This is like {@link #getFilesDir()} in that these files will be deleted when
     * the application is uninstalled, however there are some important differences:
     * <ul>
     * <li>Shared storage may not always be available, since removable media can be
     * ejected by the user. Media state can be checked using
     * {@link Environment#getExternalStorageState(File)}.
     * <li>There is no security enforced with these files. For example, any
     * application holding
     * {@link android.Manifest.permission#WRITE_EXTERNAL_STORAGE} can write to these
     * files.
     * </ul>
     * <p>
     * If a shared storage device is emulated (as determined by
     * {@link Environment#isExternalStorageEmulated(File)}), it's contents are
     * backed by a private user data partition, which means there is little benefit
     * to storing data here instead of the private directories returned by
     * {@link #getFilesDir()}, etc.
     * <p>
     * Shared storage devices returned here are considered a stable part of the
     * device, including physical media slots under a protective cover. The returned
     * paths do not include transient devices, such as USB flash drives connected to
     * handheld devices.
     * <p>
     * An application may store data on any or all of the returned devices. For
     * example, an app may choose to store large files on the device with the most
     * available space, as measured by {@link StatFs}.
     * <p>
     * No additional permissions are required for the calling app to read or write
     * files under the returned path. Write access outside of these paths on
     * secondary external storage devices is not available.
     * <p>
     * The returned path may change over time if different shared storage media is
     * inserted, so only relative paths should be persisted.
     *
     * @param type The type of files directory to return. May be {@code null} for
     *             the root of the files directory or one of the following constants
     *             for a subdirectory:
     *             {@link android.os.Environment#DIRECTORY_MUSIC},
     *             {@link android.os.Environment#DIRECTORY_PODCASTS},
     *             {@link android.os.Environment#DIRECTORY_RINGTONES},
     *             {@link android.os.Environment#DIRECTORY_ALARMS},
     *             {@link android.os.Environment#DIRECTORY_NOTIFICATIONS},
     *             {@link android.os.Environment#DIRECTORY_PICTURES}, or
     *             {@link android.os.Environment#DIRECTORY_MOVIES}.
     * @return the absolute paths to application-specific directories. Some
     *         individual paths may be {@code null} if that shared storage is not
     *         currently available. The first path returned is the same as
     *         {@link #getExternalFilesDir(String)}.
     * @see #getExternalFilesDir(String)
     * @see Environment#getExternalStorageState(File)
     * @see Environment#isExternalStorageEmulated(File)
     * @see Environment#isExternalStorageRemovable(File)
     */
    public abstract File[] getExternalFilesDirs(String type);

    /**
     * Return the primary shared/external storage directory where this application's
     * OBB files (if there are any) can be found. Note if the application does not
     * have any OBB files, this directory may not exist.
     * <p>
     * This is like {@link #getFilesDir()} in that these files will be deleted when
     * the application is uninstalled, however there are some important differences:
     * <ul>
     * <li>Shared storage may not always be available, since removable media can be
     * ejected by the user. Media state can be checked using
     * {@link Environment#getExternalStorageState(File)}.
     * <li>There is no security enforced with these files. For example, any
     * application holding
     * {@link android.Manifest.permission#WRITE_EXTERNAL_STORAGE} can write to these
     * files.
     * </ul>
     * <p>
     * Starting in {@link android.os.Build.VERSION_CODES#KITKAT}, no permissions are
     * required to read or write to the path that this method returns. However,
     * starting from {@link android.os.Build.VERSION_CODES#M}, to read the OBB
     * expansion files, you must declare the
     * {@link android.Manifest.permission#READ_EXTERNAL_STORAGE} permission in the
     * app manifest and ask for permission at runtime as follows:
     * </p>
     * <p>
     * {@code <uses-permission android:name=
     * "android.permission.READ_EXTERNAL_STORAGE"
     * android:maxSdkVersion="23" />}
     * </p>
     * <p>
     * Starting from {@link android.os.Build.VERSION_CODES#N},
     * {@link android.Manifest.permission#READ_EXTERNAL_STORAGE} permission is not
     * required, so don't ask for this permission at runtime. To handle both cases,
     * your app must first try to read the OBB file, and if it fails, you must
     * request {@link android.Manifest.permission#READ_EXTERNAL_STORAGE} permission
     * at runtime.
     * </p>
     *
     * <p>
     * The following code snippet shows how to do this:
     * </p>
     *
     * <pre>
     * File obb = new File(obb_filename);
     * boolean open_failed = false;
     *
     * try {
     *     BufferedReader br = new BufferedReader(new FileReader(obb));
     *     open_failed = false;
     *     ReadObbFile(br);
     * } catch (IOException e) {
     *     open_failed = true;
     * }
     *
     * if (open_failed) {
     *     // request READ_EXTERNAL_STORAGE permission before reading OBB file
     *     ReadObbFileWithPermission();
     * }
     * </pre>
     *
     * On devices with multiple users (as described by {@link UserManager}),
     * multiple users may share the same OBB storage location. Applications should
     * ensure that multiple instances running under different users don't interfere
     * with each other.
     *
     * @return the absolute path to application-specific directory. May return
     *         {@code null} if shared storage is not currently available.
     * @see #getObbDirs()
     * @see Environment#getExternalStorageState(File)
     * @see Environment#isExternalStorageEmulated(File)
     * @see Environment#isExternalStorageRemovable(File)
     */
    public abstract File getObbDir();

    /**
     * Returns absolute paths to application-specific directories on all
     * shared/external storage devices where the application's OBB files (if there
     * are any) can be found. Note if the application does not have any OBB files,
     * these directories may not exist.
     * <p>
     * This is like {@link #getFilesDir()} in that these files will be deleted when
     * the application is uninstalled, however there are some important differences:
     * <ul>
     * <li>Shared storage may not always be available, since removable media can be
     * ejected by the user. Media state can be checked using
     * {@link Environment#getExternalStorageState(File)}.
     * <li>There is no security enforced with these files. For example, any
     * application holding
     * {@link android.Manifest.permission#WRITE_EXTERNAL_STORAGE} can write to these
     * files.
     * </ul>
     * <p>
     * Shared storage devices returned here are considered a stable part of the
     * device, including physical media slots under a protective cover. The returned
     * paths do not include transient devices, such as USB flash drives connected to
     * handheld devices.
     * <p>
     * An application may store data on any or all of the returned devices. For
     * example, an app may choose to store large files on the device with the most
     * available space, as measured by {@link StatFs}.
     * <p>
     * No additional permissions are required for the calling app to read or write
     * files under the returned path. Write access outside of these paths on
     * secondary external storage devices is not available.
     *
     * @return the absolute paths to application-specific directories. Some
     *         individual paths may be {@code null} if that shared storage is not
     *         currently available. The first path returned is the same as
     *         {@link #getObbDir()}
     * @see #getObbDir()
     * @see Environment#getExternalStorageState(File)
     * @see Environment#isExternalStorageEmulated(File)
     * @see Environment#isExternalStorageRemovable(File)
     */
    public abstract File[] getObbDirs();

    /**
     * Returns the absolute path to the application specific cache directory on the
     * filesystem.
     * <p>
     * The system will automatically delete files in this directory as disk space is
     * needed elsewhere on the device. The system will always delete older files
     * first, as reported by {@link File#lastModified()}. If desired, you can exert
     * more control over how files are deleted using
     * {@link StorageManager#setCacheBehaviorGroup(File, boolean)} and
     * {@link StorageManager#setCacheBehaviorTombstone(File, boolean)}.
     * <p>
     * Apps are strongly encouraged to keep their usage of cache space below the
     * quota returned by {@link StorageManager#getCacheQuotaBytes(java.util.UUID)}.
     * If your app goes above this quota, your cached files will be some of the
     * first to be deleted when additional disk space is needed. Conversely, if your
     * app stays under this quota, your cached files will be some of the last to be
     * deleted when additional disk space is needed.
     * <p>
     * Note that your cache quota will change over time depending on how frequently
     * the user interacts with your app, and depending on how much system-wide disk
     * space is used.
     * <p>
     * The returned path may change over time if the calling app is moved to an
     * adopted storage device, so only relative paths should be persisted.
     * <p>
     * Apps require no extra permissions to read or write to the returned path,
     * since this path lives in their private storage.
     *
     * @return The path of the directory holding application cache files.
     * @see #openFileOutput
     * @see #getFileStreamPath
     * @see #getDir
     * @see #getExternalCacheDir
     */
    public abstract File getCacheDir();

    /**
     * Returns the absolute path to the application specific cache directory on the
     * filesystem designed for storing cached code.
     * <p>
     * The system will delete any files stored in this location both when your
     * specific application is upgraded, and when the entire platform is upgraded.
     * <p>
     * This location is optimal for storing compiled or optimized code generated by
     * your application at runtime.
     * <p>
     * The returned path may change over time if the calling app is moved to an
     * adopted storage device, so only relative paths should be persisted.
     * <p>
     * Apps require no extra permissions to read or write to the returned path,
     * since this path lives in their private storage.
     *
     * @return The path of the directory holding application code cache files.
     */
    public abstract File getCodeCacheDir();

    /**
     * Returns absolute path to application-specific directory on the primary
     * shared/external storage device where the application can place cache files it
     * owns. These files are internal to the application, and not typically visible
     * to the user as media.
     * <p>
     * This is like {@link #getCacheDir()} in that these files will be deleted when
     * the application is uninstalled, however there are some important differences:
     * <ul>
     * <li>The platform does not always monitor the space available in shared
     * storage, and thus may not automatically delete these files. Apps should
     * always manage the maximum space used in this location. Currently the only
     * time files here will be deleted by the platform is when running on
     * {@link android.os.Build.VERSION_CODES#JELLY_BEAN_MR1} or later and
     * {@link Environment#isExternalStorageEmulated(File)} returns true.
     * <li>Shared storage may not always be available, since removable media can be
     * ejected by the user. Media state can be checked using
     * {@link Environment#getExternalStorageState(File)}.
     * <li>There is no security enforced with these files. For example, any
     * application holding
     * {@link android.Manifest.permission#WRITE_EXTERNAL_STORAGE} can write to these
     * files.
     * </ul>
     * <p>
     * If a shared storage device is emulated (as determined by
     * {@link Environment#isExternalStorageEmulated(File)}), its contents are backed
     * by a private user data partition, which means there is little benefit to
     * storing data here instead of the private directory returned by
     * {@link #getCacheDir()}.
     * <p>
     * Starting in {@link android.os.Build.VERSION_CODES#KITKAT}, no permissions are
     * required to read or write to the returned path; it's always accessible to the
     * calling app. This only applies to paths generated for package name of the
     * calling application. To access paths belonging to other packages,
     * {@link android.Manifest.permission#WRITE_EXTERNAL_STORAGE} and/or
     * {@link android.Manifest.permission#READ_EXTERNAL_STORAGE} are required.
     * <p>
     * On devices with multiple users (as described by {@link UserManager}), each
     * user has their own isolated shared storage. Applications only have access to
     * the shared storage for the user they're running as.
     * <p>
     * The returned path may change over time if different shared storage media is
     * inserted, so only relative paths should be persisted.
     *
     * @return the absolute path to application-specific directory. May return
     *         {@code null} if shared storage is not currently available.
     * @see #getCacheDir
     * @see #getExternalCacheDirs()
     * @see Environment#getExternalStorageState(File)
     * @see Environment#isExternalStorageEmulated(File)
     * @see Environment#isExternalStorageRemovable(File)
     */
    public abstract File getExternalCacheDir();

    /**
     * Returns absolute path to application-specific directory in the preloaded
     * cache.
     * <p>
     * Files stored in the cache directory can be deleted when the device runs low
     * on storage. There is no guarantee when these files will be deleted.
     * 
     * @hide
     */
    public abstract File getPreloadsFileCache();

    /**
     * Returns absolute paths to application-specific directories on all
     * shared/external storage devices where the application can place cache files
     * it owns. These files are internal to the application, and not typically
     * visible to the user as media.
     * <p>
     * This is like {@link #getCacheDir()} in that these files will be deleted when
     * the application is uninstalled, however there are some important differences:
     * <ul>
     * <li>The platform does not always monitor the space available in shared
     * storage, and thus may not automatically delete these files. Apps should
     * always manage the maximum space used in this location. Currently the only
     * time files here will be deleted by the platform is when running on
     * {@link android.os.Build.VERSION_CODES#JELLY_BEAN_MR1} or later and
     * {@link Environment#isExternalStorageEmulated(File)} returns true.
     * <li>Shared storage may not always be available, since removable media can be
     * ejected by the user. Media state can be checked using
     * {@link Environment#getExternalStorageState(File)}.
     * <li>There is no security enforced with these files. For example, any
     * application holding
     * {@link android.Manifest.permission#WRITE_EXTERNAL_STORAGE} can write to these
     * files.
     * </ul>
     * <p>
     * If a shared storage device is emulated (as determined by
     * {@link Environment#isExternalStorageEmulated(File)}), it's contents are
     * backed by a private user data partition, which means there is little benefit
     * to storing data here instead of the private directory returned by
     * {@link #getCacheDir()}.
     * <p>
     * Shared storage devices returned here are considered a stable part of the
     * device, including physical media slots under a protective cover. The returned
     * paths do not include transient devices, such as USB flash drives connected to
     * handheld devices.
     * <p>
     * An application may store data on any or all of the returned devices. For
     * example, an app may choose to store large files on the device with the most
     * available space, as measured by {@link StatFs}.
     * <p>
     * No additional permissions are required for the calling app to read or write
     * files under the returned path. Write access outside of these paths on
     * secondary external storage devices is not available.
     * <p>
     * The returned paths may change over time if different shared storage media is
     * inserted, so only relative paths should be persisted.
     *
     * @return the absolute paths to application-specific directories. Some
     *         individual paths may be {@code null} if that shared storage is not
     *         currently available. The first path returned is the same as
     *         {@link #getExternalCacheDir()}.
     * @see #getExternalCacheDir()
     * @see Environment#getExternalStorageState(File)
     * @see Environment#isExternalStorageEmulated(File)
     * @see Environment#isExternalStorageRemovable(File)
     */
    public abstract File[] getExternalCacheDirs();

    /**
     * Returns absolute paths to application-specific directories on all
     * shared/external storage devices where the application can place media files.
     * These files are scanned and made available to other apps through
     * {@link MediaStore}.
     * <p>
     * This is like {@link #getExternalFilesDirs} in that these files will be
     * deleted when the application is uninstalled, however there are some important
     * differences:
     * <ul>
     * <li>Shared storage may not always be available, since removable media can be
     * ejected by the user. Media state can be checked using
     * {@link Environment#getExternalStorageState(File)}.
     * <li>There is no security enforced with these files. For example, any
     * application holding
     * {@link android.Manifest.permission#WRITE_EXTERNAL_STORAGE} can write to these
     * files.
     * </ul>
     * <p>
     * Shared storage devices returned here are considered a stable part of the
     * device, including physical media slots under a protective cover. The returned
     * paths do not include transient devices, such as USB flash drives connected to
     * handheld devices.
     * <p>
     * An application may store data on any or all of the returned devices. For
     * example, an app may choose to store large files on the device with the most
     * available space, as measured by {@link StatFs}.
     * <p>
     * No additional permissions are required for the calling app to read or write
     * files under the returned path. Write access outside of these paths on
     * secondary external storage devices is not available.
     * <p>
     * The returned paths may change over time if different shared storage media is
     * inserted, so only relative paths should be persisted.
     *
     * @return the absolute paths to application-specific directories. Some
     *         individual paths may be {@code null} if that shared storage is not
     *         currently available.
     * @see Environment#getExternalStorageState(File)
     * @see Environment#isExternalStorageEmulated(File)
     * @see Environment#isExternalStorageRemovable(File)
     */
    public abstract File[] getExternalMediaDirs();

    /**
     * Returns an array of strings naming the private files associated with this
     * Context's application package.
     *
     * @return Array of strings naming the private files.
     *
     * @see #openFileInput
     * @see #openFileOutput
     * @see #deleteFile
     */
    public abstract String[] fileList();

    /**
     * Retrieve, creating if needed, a new directory in which the application can
     * place its own custom data files. You can use the returned File object to
     * create and access files in this directory. Note that files created through a
     * File object will only be accessible by your own application; you can only set
     * the mode of the entire directory, not of individual files.
     * <p>
     * The returned path may change over time if the calling app is moved to an
     * adopted storage device, so only relative paths should be persisted.
     * <p>
     * Apps require no extra permissions to read or write to the returned path,
     * since this path lives in their private storage.
     *
     * @param name Name of the directory to retrieve. This is a directory that is
     *             created as part of your application data.
     * @param mode Operating mode.
     *
     * @return A {@link File} object for the requested directory. The directory will
     *         have been created if it does not already exist.
     *
     * @see #openFileOutput(String, int)
     */
    public abstract File getDir(String name, int mode);

    /**
     * Same as {@link #startActivity(Intent, Bundle)} with no options specified.
     *
     * @param intent The description of the activity to start.
     *
     * @throws ActivityNotFoundException &nbsp; `
     * @see #startActivity(Intent, Bundle)
     * @see PackageManager#resolveActivity
     */
    public abstract void startActivity(Intent intent);

    /**
     * Launch a new activity. You will not receive any information about when the
     * activity exits.
     *
     * <p>
     * Note that if this method is being called from outside of an
     * {@link android.app.Activity} Context, then the Intent must include the
     * {@link Intent#FLAG_ACTIVITY_NEW_TASK} launch flag. This is because, without
     * being started from an existing Activity, there is no existing task in which
     * to place the new activity and thus it needs to be placed in its own separate
     * task.
     *
     * <p>
     * This method throws {@link ActivityNotFoundException} if there was no Activity
     * found to run the given Intent.
     *
     * @param intent  The description of the activity to start.
     * @param options Additional options for how the Activity should be started. May
     *                be null if there are no options. See
     *                {@link android.app.ActivityOptions} for how to build the
     *                Bundle supplied here; there are no supported definitions for
     *                building it manually.
     *
     * @throws ActivityNotFoundException &nbsp;
     *
     * @see #startActivity(Intent)
     * @see PackageManager#resolveActivity
     */
    public abstract void startActivity(Intent intent, Bundle options);

    /**
     * Identifies whether this Context instance will be able to process calls to
     * {@link #startActivityForResult(String, Intent, int, Bundle)}.
     * 
     * @hide
     */
    public boolean canStartActivityForResult() {
        return false;
    }

    /**
     * Same as {@link #startActivities(Intent[], Bundle)} with no options specified.
     *
     * @param intents An array of Intents to be started.
     *
     * @throws ActivityNotFoundException &nbsp;
     *
     * @see #startActivities(Intent[], Bundle)
     * @see PackageManager#resolveActivity
     */
    public abstract void startActivities(Intent[] intents);

    /**
     * Launch multiple new activities. This is generally the same as calling
     * {@link #startActivity(Intent)} for the first Intent in the array, that
     * activity during its creation calling {@link #startActivity(Intent)} for the
     * second entry, etc. Note that unlike that approach, generally none of the
     * activities except the last in the array will be created at this point, but
     * rather will be created when the user first visits them (due to pressing back
     * from the activity on top).
     *
     * <p>
     * This method throws {@link ActivityNotFoundException} if there was no Activity
     * found for <em>any</em> given Intent. In this case the state of the activity
     * stack is undefined (some Intents in the list may be on it, some not), so you
     * probably want to avoid such situations.
     *
     * @param intents An array of Intents to be started.
     * @param options Additional options for how the Activity should be started. See
     *                {@link android.content.Context#startActivity(Intent, Bundle)}
     *                Context.startActivity(Intent, Bundle)} for more details.
     *
     * @throws ActivityNotFoundException &nbsp;
     *
     * @see #startActivities(Intent[])
     * @see PackageManager#resolveActivity
     */
    public abstract void startActivities(Intent[] intents, Bundle options);

    /**
     * Broadcast the given intent to all interested BroadcastReceivers. This call is
     * asynchronous; it returns immediately, and you will continue executing while
     * the receivers are run. No results are propagated from receivers and receivers
     * can not abort the broadcast. If you want to allow receivers to propagate
     * results or abort the broadcast, you must send an ordered broadcast using
     * {@link #sendOrderedBroadcast(Intent, String)}.
     *
     * <p>
     * See {@link BroadcastReceiver} for more information on Intent broadcasts.
     *
     * @param intent The Intent to broadcast; all receivers matching this Intent
     *               will receive the broadcast.
     *
     * @see android.content.BroadcastReceiver
     * @see #registerReceiver
     * @see #sendBroadcast(Intent, String)
     * @see #sendOrderedBroadcast(Intent, String)
     * @see #sendOrderedBroadcast(Intent, String, BroadcastReceiver, Handler, int,
     *      String, Bundle)
     */
    public abstract void sendBroadcast(Intent intent);

    /**
     * Broadcast the given intent to all interested BroadcastReceivers, allowing an
     * optional required permission to be enforced. This call is asynchronous; it
     * returns immediately, and you will continue executing while the receivers are
     * run. No results are propagated from receivers and receivers can not abort the
     * broadcast. If you want to allow receivers to propagate results or abort the
     * broadcast, you must send an ordered broadcast using
     * {@link #sendOrderedBroadcast(Intent, String)}.
     *
     * <p>
     * See {@link BroadcastReceiver} for more information on Intent broadcasts.
     *
     * @param intent             The Intent to broadcast; all receivers matching
     *                           this Intent will receive the broadcast.
     * @param receiverPermission (optional) String naming a permission that a
     *                           receiver must hold in order to receive your
     *                           broadcast. If null, no permission is required.
     *
     * @see android.content.BroadcastReceiver
     * @see #registerReceiver
     * @see #sendBroadcast(Intent)
     * @see #sendOrderedBroadcast(Intent, String)
     * @see #sendOrderedBroadcast(Intent, String, BroadcastReceiver, Handler, int,
     *      String, Bundle)
     */
    public abstract void sendBroadcast(Intent intent, String receiverPermission);

    /**
     * Like {@link #sendBroadcast(Intent, String)}, but also allows specification of
     * an associated app op as per {@link android.app.AppOpsManager}.
     * 
     * @hide
     */
    public abstract void sendBroadcast(Intent intent, String receiverPermission, int appOp);

    /**
     * Broadcast the given intent to all interested BroadcastReceivers, allowing
     * an array of required permissions to be enforced.  This call is asynchronous; it returns
     * immediately, and you will continue executing while the receivers are run.  No results are
     * propagated from receivers and receivers can not abort the broadcast. If you want to allow
     * receivers to propagate results or abort the broadcast, you must send an ordered broadcast
     * using {@link #sendOrderedBroadcast(Intent, String)}.
     *
     * <p>See {@link BroadcastReceiver} for more information on Intent broadcasts.
     *
     * @param intent The Intent to broadcast; all receivers matching this
     *               Intent will receive the broadcast.
     * @param receiverPermissions Array of names of permissions that a receiver must hold
     *                            in order to receive your broadcast.
     *                            If empty, no permissions are required.
     *
     * @see android.content.BroadcastReceiver
     * @see #registerReceiver
     * @see #sendBroadcast(Intent)
     * @see #sendOrderedBroadcast(Intent, String)
     * @see #sendOrderedBroadcast(Intent, String, BroadcastReceiver, Handler, int, String, Bundle)
     * @hide
     */    
    public abstract void sendBroadcastWithMultiplePermissions (Intent intent, String[] receiverPermissions);

    /**
     * Broadcast the given intent to all interested BroadcastReceivers, delivering
     * them one at a time to allow more preferred receivers to consume the
     * broadcast before it is delivered to less preferred receivers.  This
     * call is asynchronous; it returns immediately, and you will continue
     * executing while the receivers are run.
     *
     * <p>See {@link BroadcastReceiver} for more information on Intent broadcasts.
     *
     * @param intent The Intent to broadcast; all receivers matching this
     *               Intent will receive the broadcast.
     * @param receiverPermission (optional) String naming a permissions that
     *               a receiver must hold in order to receive your broadcast.
     *               If null, no permission is required.
     *
     * @see android.content.BroadcastReceiver
     * @see #registerReceiver
     * @see #sendBroadcast(Intent)
     * @see #sendOrderedBroadcast(Intent, String, BroadcastReceiver, Handler, int, String, Bundle)
     */
    public abstract void sendOrderedBroadcast(Intent intent, String receiverPermission);    
}