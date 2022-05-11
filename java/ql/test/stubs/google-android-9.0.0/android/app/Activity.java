/*
 * Copyright (C) 2006 The Android Open Source Project
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

package android.app;

import java.io.FileDescriptor;
import java.io.PrintWriter;
import android.annotation.NonNull;
import android.annotation.Nullable;
import android.annotation.RequiresPermission;
import android.content.ComponentName;
import android.content.ContextWrapper;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.UserHandle;
import android.view.View;

public class Activity extends ContextWrapper {
    public static final int RESULT_OK = -1;

    public void onCreate(Bundle savedInstanceState) {}

    public Intent getIntent() {
        return null;
    }

    public void setIntent(Intent newIntent) {}

    public final boolean isChild() {
        return false;
    }

    public final Activity getParent() {
        return null;
    }

    public View getCurrentFocus() {
        return null;
    }

    public void onStateNotSaved() {}

    public boolean isVoiceInteraction() {
        return false;
    }

    public boolean isVoiceInteractionRoot() {
        return false;
    }

    public boolean isLocalVoiceInteractionSupported() {
        return false;
    }

    public void startLocalVoiceInteraction(Bundle privateOptions) {}

    public void onLocalVoiceInteractionStarted() {}

    public void onLocalVoiceInteractionStopped() {}

    public void stopLocalVoiceInteraction() {}

    public CharSequence onCreateDescription() {
        return null;
    }

    public void onProvideAssistData(Bundle data) {}

    public final void requestShowKeyboardShortcuts() {}

    public final void dismissKeyboardShortcutsHelper() {}

    public boolean showAssist(Bundle args) {
        return false;
    }

    public void reportFullyDrawn() {}

    public void onMultiWindowModeChanged(boolean isInMultiWindowMode) {}

    public boolean isInMultiWindowMode() {
        return false;
    }

    public void onPictureInPictureModeChanged(boolean isInPictureInPictureMode) {}

    public boolean isInPictureInPictureMode() {
        return false;
    }

    public void enterPictureInPictureMode() {}

    public int getMaxNumPictureInPictureActions() {
        return 0;
    }

    public int getChangingConfigurations() {
        return 0;
    }

    public Object getLastNonConfigurationInstance() {
        return null;
    }

    public Object onRetainNonConfigurationInstance() {
        return null;
    }

    public void onLowMemory() {}

    public void onTrimMemory(int level) {}

    public void setPersistent(boolean isPersistent) {}

    public void setContentView(View view) {}

    public void setContentView(int layoutResID) {}

    public void setFinishOnTouchOutside(boolean finish) {}

    public void onBackPressed() {}

    public void onUserInteraction() {}

    public void onContentChanged() {}

    public void onWindowFocusChanged(boolean hasFocus) {}

    public void onAttachedToWindow() {}

    public void onDetachedFromWindow() {}

    public boolean hasWindowFocus() {
        return false;
    }

    public View onCreatePanelView(int featureId) {
        return null;
    }

    public void invalidateOptionsMenu() {}

    public boolean onNavigateUp() {
        return false;
    }

    public boolean onNavigateUpFromChild(Activity child) {
        return false;
    }

    public void openOptionsMenu() {}

    public void closeOptionsMenu() {}

    public void registerForContextMenu(View view) {}

    public void unregisterForContextMenu(View view) {}

    public void openContextMenu(View view) {}

    public void closeContextMenu() {}

    public final void showDialog(int id) {}

    public final boolean showDialog(int id, Bundle args) {
        return false;
    }

    public final void dismissDialog(int id) {}

    public final void removeDialog(int id) {}

    public boolean onSearchRequested() {
        return false;
    }

    public void startSearch(@Nullable String initialQuery, boolean selectInitialQuery,
            @Nullable Bundle appSearchData, boolean globalSearch) {}

    public void triggerSearch(String query, @Nullable Bundle appSearchData) {}

    public void takeKeyEvents(boolean get) {}

    public final boolean requestWindowFeature(int featureId) {
        return false;
    }

    public final void setFeatureDrawableUri(int featureId, Uri uri) {}

    public final void setFeatureDrawableAlpha(int featureId, int alpha) {}

    public final void requestPermissions(@NonNull String[] permissions, int requestCode) {}

    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,
            @NonNull int[] grantResults) {}

    public boolean shouldShowRequestPermissionRationale(@NonNull String permission) {
        return false;
    }

    public void startActivityForResult(@RequiresPermission Intent intent, int requestCode) {}

    public void startActivityForResult(@RequiresPermission Intent intent, int requestCode,
            @Nullable Bundle options) {}

    public boolean isActivityTransitionRunning() {
        return false;
    }

    public void startActivityForResultAsUser(Intent intent, int requestCode, UserHandle user) {}

    public void startActivityForResultAsUser(Intent intent, int requestCode,
            @Nullable Bundle options, UserHandle user) {}

    public void startActivityForResultAsUser(Intent intent, String resultWho, int requestCode,
            @Nullable Bundle options, UserHandle user) {}

    public void startActivityAsUser(Intent intent, UserHandle user) {}

    public void startActivityAsUser(Intent intent, Bundle options, UserHandle user) {}

    public void startActivityAsCaller(Intent intent, @Nullable Bundle options,
            boolean ignoreTargetSecurity, int userId) {}

    @Override
    public void startActivity(Intent intent) {}

    @Override
    public void startActivity(Intent intent, @Nullable Bundle options) {}

    @Override
    public void startActivities(Intent[] intents) {}

    @Override
    public void startActivities(Intent[] intents, @Nullable Bundle options) {}

    public boolean startActivityIfNeeded(@RequiresPermission @NonNull Intent intent,
            int requestCode) {
        return false;
    }

    public boolean startActivityIfNeeded(@RequiresPermission @NonNull Intent intent,
            int requestCode, @Nullable Bundle options) {
        return false;
    }

    public boolean startNextMatchingActivity(@RequiresPermission @NonNull Intent intent) {
        return false;
    }

    public boolean startNextMatchingActivity(@RequiresPermission @NonNull Intent intent,
            @Nullable Bundle options) {
        return false;
    }

    public void startActivityFromChild(@NonNull Activity child, @RequiresPermission Intent intent,
            int requestCode) {}

    public void startActivityFromChild(@NonNull Activity child, @RequiresPermission Intent intent,
            int requestCode, @Nullable Bundle options) {}

    public void startActivityFromFragment(@NonNull Fragment fragment,
            @RequiresPermission Intent intent, int requestCode) {}

    public void startActivityFromFragment(@NonNull Fragment fragment,
            @RequiresPermission Intent intent, int requestCode, @Nullable Bundle options) {}

    public void startActivityAsUserFromFragment(@NonNull Fragment fragment,
            @RequiresPermission Intent intent, int requestCode, @Nullable Bundle options,
            UserHandle user) {}

    @Override
    public void startActivityForResult(String who, Intent intent, int requestCode,
            @Nullable Bundle options) {}

    @Override
    public boolean canStartActivityForResult() {
        return false;
    }

    public void overridePendingTransition(int enterAnim, int exitAnim) {}

    public final void setResult(int resultCode) {}

    public final void setResult(int resultCode, Intent data) {}

    public Uri getReferrer() {
        return null;
    }

    public Uri onProvideReferrer() {
        return null;
    }

    public String getCallingPackage() {
        return null;
    }

    public ComponentName getCallingActivity() {
        return null;
    }

    public void setVisible(boolean visible) {}

    public boolean isFinishing() {
        return false;
    }

    public boolean isDestroyed() {
        return false;
    }

    public boolean isChangingConfigurations() {
        return false;
    }

    public void recreate() {}

    public void finish() {}

    public void finishAffinity() {}

    public void finishFromChild(Activity child) {}

    public void finishAfterTransition() {}

    public void finishActivity(int requestCode) {}

    public void finishActivityFromChild(@NonNull Activity child, int requestCode) {}

    public void finishAndRemoveTask() {}

    public boolean releaseInstance() {
        return false;
    }

    public void onActivityReenter(int resultCode, Intent data) {}

    protected void onActivityResult(int requestCode, int resultCode, Intent data) {}

    public int getRequestedOrientation() {
        return 0;
    }

    public int getTaskId() {
        return 0;
    }

    public boolean moveTaskToBack(boolean nonRoot) {
        return false;
    }

    public String getLocalClassName() {
        return null;
    }

    public ComponentName getComponentName() {
        return null;
    }

    @Override
    public Object getSystemService(@NonNull String name) {
        return null;
    }

    public void setTitle(CharSequence title) {}

    public void setTitle(int titleId) {}

    public void setTitleColor(int textColor) {}

    public final CharSequence getTitle() {
        return null;
    }

    public final int getTitleColor() {
        return 0;
    }

    public final void setProgressBarVisibility(boolean visible) {}

    public final void setProgressBarIndeterminateVisibility(boolean visible) {}

    public final void setProgressBarIndeterminate(boolean indeterminate) {}

    public final void setProgress(int progress) {}

    public final void setSecondaryProgress(int secondaryProgress) {}

    public final void setVolumeControlStream(int streamType) {}

    public final int getVolumeControlStream() {
        return 0;
    }

    public final void runOnUiThread(Runnable action) {}

    public void dump(String prefix, FileDescriptor fd, PrintWriter writer, String[] args) {}

    public boolean isImmersive() {
        return false;
    }

    public void convertFromTranslucent() {}

    public boolean requestVisibleBehind(boolean visible) {
        return false;
    }

    public void onVisibleBehindCanceled() {}

    public boolean isBackgroundVisibleBehind() {
        return false;
    }

    public void onBackgroundVisibleBehindChanged(boolean visible) {}

    public void onEnterAnimationComplete() {}

    public void dispatchEnterAnimationComplete() {}

    public void setImmersive(boolean i) {}

    public boolean shouldUpRecreateTask(Intent targetIntent) {
        return false;
    }

    public boolean navigateUpTo(Intent upIntent) {
        return false;
    }

    public boolean navigateUpToFromChild(Activity child, Intent upIntent) {
        return false;
    }

    public Intent getParentActivityIntent() {
        return null;
    }

    public void postponeEnterTransition() {}

    public void startPostponedEnterTransition() {}

    public final boolean isResumed() {
        return false;
    }

    public void startLockTask() {}

    public void stopLockTask() {}

    public void showLockTaskEscapeMessage() {}

    public boolean isOverlayWithDecorCaptionEnabled() {
        return false;
    }

    public void setOverlayWithDecorCaptionEnabled(boolean enabled) {}

    public interface TranslucentConversionListener {
        public void onTranslucentConversionComplete(boolean drawComplete);

    }

    public final @Nullable View autofillClientFindViewByAccessibilityIdTraversal(int viewId,
            int windowId) {
        return null;
    }

    public void setDisablePreviewScreenshots(boolean disable) {}

    public void setShowWhenLocked(boolean showWhenLocked) {}

    public void setTurnScreenOn(boolean turnScreenOn) {}

    public <T extends View> T findViewById(int id) {
        return null;
    }
}
