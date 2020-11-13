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

package android.content.pm;

// import android.Manifest;
// import android.annotation.CheckResult;
// import android.annotation.DrawableRes;
// import android.annotation.IntDef;
// import android.annotation.IntRange;
// import android.annotation.NonNull;
// import android.annotation.Nullable;
// import android.annotation.RequiresPermission;
// import android.annotation.SdkConstant;
// import android.annotation.SdkConstant.SdkConstantType;
// import android.annotation.StringRes;
// import android.annotation.SystemApi;
// import android.annotation.TestApi;
// import android.annotation.UserIdInt;
// import android.annotation.XmlRes;
// import android.app.ActivityManager;
// import android.app.ActivityThread;
// import android.app.AppDetailsActivity;
// import android.app.PackageDeleteObserver;
// import android.app.PackageInstallObserver;
// import android.app.PropertyInvalidatedCache;
// import android.app.admin.DevicePolicyManager;
// import android.app.usage.StorageStatsManager;
// import android.compat.annotation.ChangeId;
// import android.compat.annotation.EnabledSince;
// import android.compat.annotation.UnsupportedAppUsage;
// import android.content.ComponentName;
// import android.content.Context;
// import android.content.Intent;
// import android.content.IntentFilter;
// import android.content.IntentSender;
// import android.content.pm.dex.ArtManager;
// import android.content.pm.parsing.PackageInfoWithoutStateUtils;
// import android.content.pm.parsing.ParsingPackage;
// import android.content.pm.parsing.ParsingPackageUtils;
// import android.content.pm.parsing.result.ParseInput;
// import android.content.pm.parsing.result.ParseResult;
// import android.content.pm.parsing.result.ParseTypeImpl;
// import android.content.res.Resources;
// import android.content.res.XmlResourceParser;
// import android.graphics.Rect;
// import android.graphics.drawable.AdaptiveIconDrawable;
// import android.graphics.drawable.Drawable;
// import android.net.wifi.WifiManager;
// import android.os.Build;
// import android.os.Bundle;
// import android.os.Handler;
// import android.os.PersistableBundle;
// import android.os.RemoteException;
// import android.os.UserHandle;
// import android.os.UserManager;
// import android.os.incremental.IncrementalManager;
// import android.os.storage.StorageManager;
// import android.os.storage.VolumeInfo;
// import android.permission.PermissionManager;
// import android.util.AndroidException;
// import android.util.Log;

// import com.android.internal.util.ArrayUtils;

// import dalvik.system.VMRuntime;

import java.io.File;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.Set;

/**
 * Class for retrieving various kinds of information related to the application
 * packages that are currently installed on the device.
 *
 * You can find this class through {@link Context#getPackageManager}.
 */
public abstract class PackageManager {
    private static final String TAG = "PackageManager";

    /** {@hide} */
    public static final boolean APPLY_DEFAULT_TO_DEVICE_PROTECTED_STORAGE = true;

    /**
     * This exception is thrown when a given package, application, or component name
     * cannot be found.
     */
    public static class NameNotFoundException extends Exception {
        public NameNotFoundException() {
        }

        public NameNotFoundException(String name) {
            super(name);
        }
    }

    /**
     * Listener for changes in permissions granted to a UID.
     *
     * @hide
     */

    public PackageManager() {
    }

    public abstract PackageInfo getPackageInfo(String packageName, int flags) throws NameNotFoundException;

    public List<PackageInfo> getInstalledPackages(int flags) {
        return null;
    };

}
