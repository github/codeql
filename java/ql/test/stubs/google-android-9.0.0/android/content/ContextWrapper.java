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
 * Proxying implementation of Context that simply delegates all of its calls to
 * another Context.  Can be subclassed to modify behavior without changing
 * the original Context.
 */
public class ContextWrapper extends Context {
    public ContextWrapper() {
    }

    public ContextWrapper(Context base) {
    }
    
    @Override
    public Context getApplicationContext() {
        return null;
    }

    @Override
    public File getFileStreamPath(String name) {
        return null;
    }

    @Override
    public SharedPreferences getSharedPreferences(String name, int mode) {
        return null;
    }

    @Override
    public File getSharedPrefsFile(String name) {
        return null;
    }

    @Override
    public String[] fileList() {
        return null;
    }

    @Override
    public File getDataDir() {
        return null;
    }

    @Override
    public File getFilesDir() {
        return null;
    }

    @Override
    public File getNoBackupFilesDir() {
        return null;
    }

    @Override
    public File getExternalFilesDir(String type) {
        return null;
    }

    @Override
    public File[] getExternalFilesDirs(String type) {
        return null;
    }

    @Override
    public File getObbDir() {
        return null;
    }

    @Override
    public File[] getObbDirs() {
        return null;
    }

    @Override
    public File getCacheDir() {
        return null;
    }

    @Override
    public File getCodeCacheDir() {
        return null;
    }

    @Override
    public File getExternalCacheDir() {
        return null;
    }

    @Override
    public File[] getExternalCacheDirs() {
        return null;
    }

    @Override
    public File[] getExternalMediaDirs() {
        return null;
    }

    @Override
    public File getDir(String name, int mode) {
        return null;
    }

    /** @hide **/
    @Override
    public File getPreloadsFileCache() {
        return null;
    }

    @Override
    public void startActivity(Intent intent) {
    }

    /** @hide **/
    public void startActivityForResult(
            String who, Intent intent, int requestCode, Bundle options) {
    }

    /** @hide **/
    public boolean canStartActivityForResult() {
        return false;
    }
    @Override

    public void startActivity(Intent intent, Bundle options) {
    }

    @Override
    public void startActivities(Intent[] intents) {
    }

    @Override
    public void startActivities(Intent[] intents, Bundle options) {
    }

    @Override
    public void sendBroadcast(Intent intent) {
    }

    @Override
    public void sendBroadcast(Intent intent, String receiverPermission) {
    }

    @Override
    public void sendBroadcastWithMultiplePermissions(Intent intent, String[] receiverPermissions) {
    }

    /** @hide */
    @Override
    public void sendBroadcast(Intent intent, String receiverPermission, int appOp) {
    }

    @Override
    public void sendOrderedBroadcast(Intent intent,
            String receiverPermission) {
    }

    @Override
    public ComponentName startService(Intent service) {
        return null;
    }

    @Override
    public ComponentName startForegroundService(Intent service) {
        return null;
    }
}
