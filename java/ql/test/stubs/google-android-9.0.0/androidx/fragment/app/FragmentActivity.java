/*
 * Copyright 2018 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */

package androidx.fragment.app;

import java.io.FileDescriptor;
import java.io.PrintWriter;
import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.content.IntentSender;
import android.content.res.Configuration;
import android.os.Bundle;
import android.util.AttributeSet;
import android.view.View;
import androidx.activity.ComponentActivity;

public class FragmentActivity extends ComponentActivity {
        public FragmentActivity() {}

        public FragmentActivity(int contentLayoutId) {}

        public void supportFinishAfterTransition() {}

        public void supportPostponeEnterTransition() {}

        public void supportStartPostponedEnterTransition() {}

        public void onMultiWindowModeChanged(boolean isInMultiWindowMode) {}

        public void onPictureInPictureModeChanged(boolean isInPictureInPictureMode) {}

        public void onConfigurationChanged(Configuration newConfig) {}

        public View onCreateView(View parent, String name, Context context, AttributeSet attrs) {
                return null;
        }

        public View onCreateView(String name, Context context, AttributeSet attrs) {
                return null;
        }

        public void onLowMemory() {}

        public void onStateNotSaved() {}

        public void supportInvalidateOptionsMenu() {}

        public void dump(String prefix, FileDescriptor fd, PrintWriter writer, String[] args) {}

        public void onAttachFragment(Fragment fragment) {}

        public FragmentManager getSupportFragmentManager() {
                return null;
        }

        public final void validateRequestPermissionsRequestCode(int requestCode) {}

        @Override
        public void onRequestPermissionsResult(int requestCode, String[] permissions,
                        int[] grantResults) {}

        public void startActivityFromFragment(Fragment fragment, Intent intent, int requestCode) {}

        public void startActivityFromFragment(Fragment fragment, Intent intent, int requestCode,
                        Bundle options) {}

        public void startIntentSenderFromFragment(Fragment fragment, IntentSender intent,
                        int requestCode, Intent fillInIntent, int flagsMask, int flagsValues,
                        int extraFlags, Bundle options) throws IntentSender.SendIntentException {}

}
