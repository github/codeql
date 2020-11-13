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

package android.app;

// import android.annotation.CallSuper;
// import android.annotation.NonNull;
// import android.annotation.Nullable;
// import android.compat.annotation.UnsupportedAppUsage;
// import android.content.ComponentCallbacks;
// import android.content.ComponentCallbacks2;
// import android.content.Context;
import android.content.ContextWrapper;
// import android.content.Intent;
// import android.content.res.Configuration;
// import android.os.Build;
import android.os.Bundle;
// import android.util.Log;
// import android.view.autofill.AutofillManager;

import java.util.ArrayList;

/**
 * Base class for maintaining global application state. You can provide your own
 * implementation by creating a subclass and specifying the fully-qualified name
 * of this subclass as the <code>"android:name"</code> attribute in your
 * AndroidManifest.xml's <code>&lt;application&gt;</code> tag. The Application
 * class, or your subclass of the Application class, is instantiated before any
 * other class when the process for your application/package is created.
 *
 * <p class="note">
 * <strong>Note: </strong>There is normally no need to subclass Application. In
 * most situations, static singletons can provide the same functionality in a
 * more modular way. If your singleton needs a global context (for example to
 * register broadcast receivers), include
 * {@link android.content.Context#getApplicationContext()
 * Context.getApplicationContext()} as a {@link android.content.Context}
 * argument when invoking your singleton's <code>getInstance()</code> method.
 * </p>
 */
public class Application {
    public interface ActivityLifecycleCallbacks {

        /**
         * Called as the first step of the Activity being created. This is always called
         * before {@link Activity#onCreate}.
         */
        default void onActivityPreCreated(Activity activity, Bundle savedInstanceState) {
        }

        /**
         * Called when the Activity calls {@link Activity#onCreate super.onCreate()}.
         */
        void onActivityCreated(Activity activity, Bundle savedInstanceState);

        /**
         * Called as the last step of the Activity being created. This is always called
         * after {@link Activity#onCreate}.
         */
        default void onActivityPostCreated(Activity activity, Bundle savedInstanceState) {
        }

        /**
         * Called as the first step of the Activity being started. This is always called
         * before {@link Activity#onStart}.
         */
        default void onActivityPreStarted(Activity activity) {
        }

        /**
         * Called when the Activity calls {@link Activity#onStart super.onStart()}.
         */
        void onActivityStarted(Activity activity);

        /**
         * Called as the last step of the Activity being started. This is always called
         * after {@link Activity#onStart}.
         */
        default void onActivityPostStarted(Activity activity) {
        }

        /**
         * Called as the first step of the Activity being resumed. This is always called
         * before {@link Activity#onResume}.
         */
        default void onActivityPreResumed(Activity activity) {
        }

        /**
         * Called when the Activity calls {@link Activity#onResume super.onResume()}.
         */
        void onActivityResumed(Activity activity);

        /**
         * Called as the last step of the Activity being resumed. This is always called
         * after {@link Activity#onResume} and {@link Activity#onPostResume}.
         */
        default void onActivityPostResumed(Activity activity) {
        }

        /**
         * Called as the first step of the Activity being paused. This is always called
         * before {@link Activity#onPause}.
         */
        default void onActivityPrePaused(Activity activity) {
        }

        /**
         * Called when the Activity calls {@link Activity#onPause super.onPause()}.
         */
        void onActivityPaused(Activity activity);

        /**
         * Called as the last step of the Activity being paused. This is always called
         * after {@link Activity#onPause}.
         */
        default void onActivityPostPaused(Activity activity) {
        }

        /**
         * Called as the first step of the Activity being stopped. This is always called
         * before {@link Activity#onStop}.
         */
        default void onActivityPreStopped(Activity activity) {
        }

        /**
         * Called when the Activity calls {@link Activity#onStop super.onStop()}.
         */
        void onActivityStopped(Activity activity);

        /**
         * Called as the last step of the Activity being stopped. This is always called
         * after {@link Activity#onStop}.
         */
        default void onActivityPostStopped(Activity activity) {
        }

        /**
         * Called as the first step of the Activity saving its instance state. This is
         * always called before {@link Activity#onSaveInstanceState}.
         */
        default void onActivityPreSaveInstanceState(Activity activity, Bundle outState) {
        }

        /**
         * Called when the Activity calls {@link Activity#onSaveInstanceState
         * super.onSaveInstanceState()}.
         */
        void onActivitySaveInstanceState(Activity activity, Bundle outState);

        /**
         * Called as the last step of the Activity saving its instance state. This is
         * always called after{@link Activity#onSaveInstanceState}.
         */
        default void onActivityPostSaveInstanceState(Activity activity, Bundle outState) {
        }

        /**
         * Called as the first step of the Activity being destroyed. This is always
         * called before {@link Activity#onDestroy}.
         */
        default void onActivityPreDestroyed(Activity activity) {
        }

        /**
         * Called when the Activity calls {@link Activity#onDestroy super.onDestroy()}.
         */
        void onActivityDestroyed(Activity activity);

        /**
         * Called as the last step of the Activity being destroyed. This is always
         * called after {@link Activity#onDestroy}.
         */
        default void onActivityPostDestroyed(Activity activity) {
        }
    }

    /**
     * Callback interface for use with
     * {@link Application#registerOnProvideAssistDataListener} and
     * {@link Application#unregisterOnProvideAssistDataListener}.
     */
    public interface OnProvideAssistDataListener {
        /**
         * This is called when the user is requesting an assist, to build a full
         * {@link Intent#ACTION_ASSIST} Intent with all of the context of the current
         * application. You can override this method to place into the bundle anything
         * you would like to appear in the {@link Intent#EXTRA_ASSIST_CONTEXT} part of
         * the assist Intent.
         */
        public void onProvideAssistData(Activity activity, Bundle data);
    }

    /**
     * Called when the application is starting, before any activity, service, or
     * receiver objects (excluding content providers) have been created.
     *
     * <p>
     * Implementations should be as quick as possible (for example using lazy
     * initialization of state) since the time spent in this function directly
     * impacts the performance of starting the first activity, service, or receiver
     * in a process.
     * </p>
     *
     * <p>
     * If you override this method, be sure to call {@code super.onCreate()}.
     * </p>
     *
     * <p class="note">
     * Be aware that direct boot may also affect callback order on Android
     * {@link android.os.Build.VERSION_CODES#N} and later devices. Until the user
     * unlocks the device, only direct boot aware components are allowed to run. You
     * should consider that all direct boot unaware components, including such
     * {@link android.content.ContentProvider}, are disabled until user unlock
     * happens, especially when component callback order matters.
     * </p>
     */
    public void onCreate() {
    }

    /**
     * This method is for use in emulated process environments. It will never be
     * called on a production Android device, where processes are removed by simply
     * killing them; no user code (including this callback) is executed when doing
     * so.
     */
    public void onTerminate() {
    }

    public void onLowMemory() {
    }

    public void onTrimMemory(int level) {
    }

}
