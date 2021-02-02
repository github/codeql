/*
 * Copyright (C) 2007 The Android Open Source Project
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

// import android.annotation.Nullable;
// import android.compat.annotation.UnsupportedAppUsage;
// import android.os.Build;
import android.os.Parcel;
import android.os.Parcelable;

/**
 * Overall information about the contents of a package. This corresponds to all
 * of the information collected from AndroidManifest.xml.
 */
public class PackageInfo implements Parcelable {
    /**
     * The name of this package. From the &lt;manifest&gt; tag's "name" attribute.
     */
    public String packageName;

    /**
     * The names of any installed split APKs for this package.
     */
    public String[] splitNames;

    /**
     * @deprecated Use {@link #getLongVersionCode()} instead, which includes both
     *             this and the additional
     *             {@link android.R.styleable#AndroidManifest_versionCodeMajor
     *             versionCodeMajor} attribute. The version number of this package,
     *             as specified by the &lt;manifest&gt; tag's
     *             {@link android.R.styleable#AndroidManifest_versionCode
     *             versionCode} attribute.
     * @see #getLongVersionCode()
     */
    @Deprecated
    public int versionCode;

    /**
     * @hide The major version number of this package, as specified by the
     *       &lt;manifest&gt; tag's
     *       {@link android.R.styleable#AndroidManifest_versionCode
     *       versionCodeMajor} attribute.
     * @see #getLongVersionCode()
     */
    public int versionCodeMajor;

    /**
     * Return {@link android.R.styleable#AndroidManifest_versionCode versionCode}
     * and {@link android.R.styleable#AndroidManifest_versionCodeMajor
     * versionCodeMajor} combined together as a single long value. The
     * {@link android.R.styleable#AndroidManifest_versionCodeMajor versionCodeMajor}
     * is placed in the upper 32 bits.
     */
    public long getLongVersionCode() {
        return composeLongVersionCode(versionCodeMajor, versionCode);
    }

    /**
     * Set the full version code in this PackageInfo, updating {@link #versionCode}
     * with the lower bits.
     * 
     * @see #getLongVersionCode()
     */
    public void setLongVersionCode(long longVersionCode) {
        versionCodeMajor = (int) (longVersionCode >> 32);
        versionCode = (int) longVersionCode;
    }

    /**
     * @hide Internal implementation for composing a minor and major version code in
     *       to a single long version code.
     */
    public static long composeLongVersionCode(int major, int minor) {
        return (((long) major) << 32) | (((long) minor) & 0xffffffffL);
    }

    /**
     * The version name of this package, as specified by the &lt;manifest&gt; tag's
     * {@link android.R.styleable#AndroidManifest_versionName versionName}
     * attribute.
     */
    public String versionName;

    /**
     * The revision number of the base APK for this package, as specified by the
     * &lt;manifest&gt; tag's
     * {@link android.R.styleable#AndroidManifest_revisionCode revisionCode}
     * attribute.
     */
    public int baseRevisionCode;

    /**
     * The revision number of any split APKs for this package, as specified by the
     * &lt;manifest&gt; tag's
     * {@link android.R.styleable#AndroidManifest_revisionCode revisionCode}
     * attribute. Indexes are a 1:1 mapping against {@link #splitNames}.
     */
    public int[] splitRevisionCodes;

    /**
     * The shared user ID name of this package, as specified by the &lt;manifest&gt;
     * tag's {@link android.R.styleable#AndroidManifest_sharedUserId sharedUserId}
     * attribute.
     */
    public String sharedUserId;

    /**
     * The shared user ID label of this package, as specified by the
     * &lt;manifest&gt; tag's
     * {@link android.R.styleable#AndroidManifest_sharedUserLabel sharedUserLabel}
     * attribute.
     */
    public int sharedUserLabel;


    /**
     * The time at which the app was first installed. Units are as per
     * {@link System#currentTimeMillis()}.
     */
    public long firstInstallTime;

    /**
     * The time at which the app was last updated. Units are as per
     * {@link System#currentTimeMillis()}.
     */
    public long lastUpdateTime;

    /**
     * All kernel group-IDs that have been assigned to this package. This is only
     * filled in if the flag {@link PackageManager#GET_GIDS} was set.
     */
    public int[] gids;
    /**
     * Array of all {@link android.R.styleable#AndroidManifestUsesPermission
     * &lt;uses-permission&gt;} tags included under &lt;manifest&gt;, or null if
     * there were none. This is only filled in if the flag
     * {@link PackageManager#GET_PERMISSIONS} was set. This list includes all
     * permissions requested, even those that were not granted or known by the
     * system at install time.
     */
    public String[] requestedPermissions;

    /**
     * Array of flags of all
     * {@link android.R.styleable#AndroidManifestUsesPermission
     * &lt;uses-permission&gt;} tags included under &lt;manifest&gt;, or null if
     * there were none. This is only filled in if the flag
     * {@link PackageManager#GET_PERMISSIONS} was set. Each value matches the
     * corresponding entry in {@link #requestedPermissions}, and will have the flag
     * {@link #REQUESTED_PERMISSION_GRANTED} set as appropriate.
     */
    public int[] requestedPermissionsFlags;

    /**
     * Flag for {@link #requestedPermissionsFlags}: the requested permission is
     * required for the application to run; the user can not optionally disable it.
     * Currently all permissions are required.
     *
     * @removed We do not support required permissions.
     */
    public static final int REQUESTED_PERMISSION_REQUIRED = 1 << 0;

    /**
     * Flag for {@link #requestedPermissionsFlags}: the requested permission is
     * currently granted to the application.
     */
    public static final int REQUESTED_PERMISSION_GRANTED = 1 << 1;
    /**
     * Constant corresponding to <code>auto</code> in the
     * {@link android.R.attr#installLocation} attribute.
     * 
     * @hide
     */
    public static final int INSTALL_LOCATION_UNSPECIFIED = -1;

    /**
     * Constant corresponding to <code>auto</code> in the
     * {@link android.R.attr#installLocation} attribute.
     */
    public static final int INSTALL_LOCATION_AUTO = 0;

    /**
     * Constant corresponding to <code>internalOnly</code> in the
     * {@link android.R.attr#installLocation} attribute.
     */
    public static final int INSTALL_LOCATION_INTERNAL_ONLY = 1;

    /**
     * Constant corresponding to <code>preferExternal</code> in the
     * {@link android.R.attr#installLocation} attribute.
     */
    public static final int INSTALL_LOCATION_PREFER_EXTERNAL = 2;

    /**
     * The install location requested by the package. From the
     * {@link android.R.attr#installLocation} attribute, one of
     * {@link #INSTALL_LOCATION_AUTO}, {@link #INSTALL_LOCATION_INTERNAL_ONLY},
     * {@link #INSTALL_LOCATION_PREFER_EXTERNAL}
     */
    public int installLocation = INSTALL_LOCATION_INTERNAL_ONLY;

    /** @hide */
    public boolean isStub;

    /** @hide */
    public boolean coreApp;

    /** @hide */
    public boolean requiredForAllUsers;

    /** @hide */
    public String restrictedAccountType;

    /** @hide */
    public String requiredAccountType;

    /**
     * What package, if any, this package will overlay.
     *
     * Package name of target package, or null.
     * 
     * @hide
     */
    public String overlayTarget;

    /**
     * The name of the overlayable set of elements package, if any, this package
     * will overlay.
     *
     * Overlayable name defined within the target package, or null.
     * 
     * @hide
     */
    public String targetOverlayableName;

    /**
     * The overlay category, if any, of this package
     *
     * @hide
     */
    public String overlayCategory;

    /** @hide */
    public int overlayPriority;

    /**
     * Whether the overlay is static, meaning it cannot be enabled/disabled at
     * runtime.
     * 
     * @hide
     */
    public boolean mOverlayIsStatic;

    /**
     * The user-visible SDK version (ex. 26) of the framework against which the
     * application claims to have been compiled, or {@code 0} if not specified.
     * <p>
     * This property is the compile-time equivalent of
     * {@link android.os.Build.VERSION#SDK_INT Build.VERSION.SDK_INT}.
     *
     * @hide For platform use only; we don't expect developers to need to read this
     *       value.
     */
    public int compileSdkVersion;

    /**
     * The development codename (ex. "O", "REL") of the framework against which the
     * application claims to have been compiled, or {@code null} if not specified.
     * <p>
     * This property is the compile-time equivalent of
     * {@link android.os.Build.VERSION#CODENAME Build.VERSION.CODENAME}.
     *
     * @hide For platform use only; we don't expect developers to need to read this
     *       value.
     */
    public String compileSdkVersionCodename;

    /**
     * Whether the package is an APEX package.
     */
    public boolean isApex;

    public PackageInfo() {
    }

    public boolean isOverlayPackage() {
        return false;
    }

    /**
     * Returns true if the package is a valid static Runtime Overlay package. Static
     * overlays are not updatable outside of a system update and are safe to load in
     * the system process.
     * 
     * @hide
     */
    public boolean isStaticOverlayPackage() {
        return false;
    }

    public String toString() {
        return "";
    }

    public int describeContents() {
        return 0;
    }

    public void writeToParcel(Parcel dest, int parcelableFlags) {
    }

    private PackageInfo(Parcel source) {

    }
}
