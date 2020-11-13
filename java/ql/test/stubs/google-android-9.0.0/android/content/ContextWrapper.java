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

import android.os.Bundle;
import android.content.pm.PackageManager;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.concurrent.Executor;

public class ContextWrapper extends Context {
    Context mBase;

    public ContextWrapper(Context base) {
        mBase = base;
    }

    // Created just for for the tests to pass
    public ContextWrapper() {
        mBase = null;
    }

    @Override
    public PackageManager getPackageManager() {
        return mBase.getPackageManager();
    }

    @Override
    public Context createPackageContext(String packageName, int flags) throws Exception {
        return mBase.createPackageContext(packageName, flags);
    }

    @Override
    public ClassLoader getClassLoader() {
        return null;
    }

    @Override
    public Context getApplicationContext() {
        return null;
    };

    @Override
    public void startActivity(Intent intent) {
    };

    @Override
    public SharedPreferences getSharedPreferences(String name, int mode) {
    };

    @Override
    public void sendOrderedBroadcast(Intent intent, String receiverPermission) {
    };

    @Override
    public void sendBroadcast(Intent intent) {
    };

    @Override
    public void sendBroadcast(Intent intent, String receiverPermission) {
    };

    @Override
    public void sendBroadcast(Intent intent, String receiverPermission, Bundle options) {
    };

    @Override
    public void sendBroadcast(Intent intent, String receiverPermission, int appOp) {
    };
}
