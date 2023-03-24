// Generated automatically from android.view.WindowManager for testing purposes

package android.view;

import android.os.IBinder;
import android.os.Parcel;
import android.os.Parcelable;
import android.view.Display;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewManager;
import android.view.WindowMetrics;
import java.util.concurrent.Executor;
import java.util.function.Consumer;

public interface WindowManager extends ViewManager
{
    Display getDefaultDisplay();
    default WindowMetrics getCurrentWindowMetrics(){ return null; }
    default WindowMetrics getMaximumWindowMetrics(){ return null; }
    default boolean isCrossWindowBlurEnabled(){ return false; }
    default void addCrossWindowBlurEnabledListener(Consumer<Boolean> p0){}
    default void addCrossWindowBlurEnabledListener(Executor p0, Consumer<Boolean> p1){}
    default void removeCrossWindowBlurEnabledListener(Consumer<Boolean> p0){}
    static public class LayoutParams extends ViewGroup.LayoutParams implements Parcelable
    {
        public IBinder token = null;
        public LayoutParams(){}
        public LayoutParams(Parcel p0){}
        public LayoutParams(int p0){}
        public LayoutParams(int p0, int p1){}
        public LayoutParams(int p0, int p1, int p2){}
        public LayoutParams(int p0, int p1, int p2, int p3, int p4){}
        public LayoutParams(int p0, int p1, int p2, int p3, int p4, int p5, int p6){}
        public String debug(String p0){ return null; }
        public String packageName = null;
        public String toString(){ return null; }
        public boolean isFitInsetsIgnoringVisibility(){ return false; }
        public boolean preferMinimalPostProcessing = false;
        public final CharSequence getTitle(){ return null; }
        public final int copyFrom(WindowManager.LayoutParams p0){ return 0; }
        public final void setTitle(CharSequence p0){}
        public float alpha = 0;
        public float buttonBrightness = 0;
        public float dimAmount = 0;
        public float horizontalMargin = 0;
        public float horizontalWeight = 0;
        public float preferredRefreshRate = 0;
        public float screenBrightness = 0;
        public float verticalMargin = 0;
        public float verticalWeight = 0;
        public int describeContents(){ return 0; }
        public int flags = 0;
        public int format = 0;
        public int getBlurBehindRadius(){ return 0; }
        public int getColorMode(){ return 0; }
        public int getFitInsetsSides(){ return 0; }
        public int getFitInsetsTypes(){ return 0; }
        public int gravity = 0;
        public int layoutInDisplayCutoutMode = 0;
        public int memoryType = 0;
        public int preferredDisplayModeId = 0;
        public int rotationAnimation = 0;
        public int screenOrientation = 0;
        public int softInputMode = 0;
        public int systemUiVisibility = 0;
        public int type = 0;
        public int windowAnimations = 0;
        public int x = 0;
        public int y = 0;
        public static Parcelable.Creator<WindowManager.LayoutParams> CREATOR = null;
        public static boolean mayUseInputMethod(int p0){ return false; }
        public static float BRIGHTNESS_OVERRIDE_FULL = 0;
        public static float BRIGHTNESS_OVERRIDE_NONE = 0;
        public static float BRIGHTNESS_OVERRIDE_OFF = 0;
        public static int ALPHA_CHANGED = 0;
        public static int ANIMATION_CHANGED = 0;
        public static int DIM_AMOUNT_CHANGED = 0;
        public static int FIRST_APPLICATION_WINDOW = 0;
        public static int FIRST_SUB_WINDOW = 0;
        public static int FIRST_SYSTEM_WINDOW = 0;
        public static int FLAGS_CHANGED = 0;
        public static int FLAG_ALLOW_LOCK_WHILE_SCREEN_ON = 0;
        public static int FLAG_ALT_FOCUSABLE_IM = 0;
        public static int FLAG_BLUR_BEHIND = 0;
        public static int FLAG_DIM_BEHIND = 0;
        public static int FLAG_DISMISS_KEYGUARD = 0;
        public static int FLAG_DITHER = 0;
        public static int FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS = 0;
        public static int FLAG_FORCE_NOT_FULLSCREEN = 0;
        public static int FLAG_FULLSCREEN = 0;
        public static int FLAG_HARDWARE_ACCELERATED = 0;
        public static int FLAG_IGNORE_CHEEK_PRESSES = 0;
        public static int FLAG_KEEP_SCREEN_ON = 0;
        public static int FLAG_LAYOUT_ATTACHED_IN_DECOR = 0;
        public static int FLAG_LAYOUT_INSET_DECOR = 0;
        public static int FLAG_LAYOUT_IN_OVERSCAN = 0;
        public static int FLAG_LAYOUT_IN_SCREEN = 0;
        public static int FLAG_LAYOUT_NO_LIMITS = 0;
        public static int FLAG_LOCAL_FOCUS_MODE = 0;
        public static int FLAG_NOT_FOCUSABLE = 0;
        public static int FLAG_NOT_TOUCHABLE = 0;
        public static int FLAG_NOT_TOUCH_MODAL = 0;
        public static int FLAG_SCALED = 0;
        public static int FLAG_SECURE = 0;
        public static int FLAG_SHOW_WALLPAPER = 0;
        public static int FLAG_SHOW_WHEN_LOCKED = 0;
        public static int FLAG_SPLIT_TOUCH = 0;
        public static int FLAG_TOUCHABLE_WHEN_WAKING = 0;
        public static int FLAG_TRANSLUCENT_NAVIGATION = 0;
        public static int FLAG_TRANSLUCENT_STATUS = 0;
        public static int FLAG_TURN_SCREEN_ON = 0;
        public static int FLAG_WATCH_OUTSIDE_TOUCH = 0;
        public static int FORMAT_CHANGED = 0;
        public static int LAST_APPLICATION_WINDOW = 0;
        public static int LAST_SUB_WINDOW = 0;
        public static int LAST_SYSTEM_WINDOW = 0;
        public static int LAYOUT_CHANGED = 0;
        public static int LAYOUT_IN_DISPLAY_CUTOUT_MODE_ALWAYS = 0;
        public static int LAYOUT_IN_DISPLAY_CUTOUT_MODE_DEFAULT = 0;
        public static int LAYOUT_IN_DISPLAY_CUTOUT_MODE_NEVER = 0;
        public static int LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES = 0;
        public static int MEMORY_TYPE_CHANGED = 0;
        public static int MEMORY_TYPE_GPU = 0;
        public static int MEMORY_TYPE_HARDWARE = 0;
        public static int MEMORY_TYPE_NORMAL = 0;
        public static int MEMORY_TYPE_PUSH_BUFFERS = 0;
        public static int ROTATION_ANIMATION_CHANGED = 0;
        public static int ROTATION_ANIMATION_CROSSFADE = 0;
        public static int ROTATION_ANIMATION_JUMPCUT = 0;
        public static int ROTATION_ANIMATION_ROTATE = 0;
        public static int ROTATION_ANIMATION_SEAMLESS = 0;
        public static int SCREEN_BRIGHTNESS_CHANGED = 0;
        public static int SCREEN_ORIENTATION_CHANGED = 0;
        public static int SOFT_INPUT_ADJUST_NOTHING = 0;
        public static int SOFT_INPUT_ADJUST_PAN = 0;
        public static int SOFT_INPUT_ADJUST_RESIZE = 0;
        public static int SOFT_INPUT_ADJUST_UNSPECIFIED = 0;
        public static int SOFT_INPUT_IS_FORWARD_NAVIGATION = 0;
        public static int SOFT_INPUT_MASK_ADJUST = 0;
        public static int SOFT_INPUT_MASK_STATE = 0;
        public static int SOFT_INPUT_MODE_CHANGED = 0;
        public static int SOFT_INPUT_STATE_ALWAYS_HIDDEN = 0;
        public static int SOFT_INPUT_STATE_ALWAYS_VISIBLE = 0;
        public static int SOFT_INPUT_STATE_HIDDEN = 0;
        public static int SOFT_INPUT_STATE_UNCHANGED = 0;
        public static int SOFT_INPUT_STATE_UNSPECIFIED = 0;
        public static int SOFT_INPUT_STATE_VISIBLE = 0;
        public static int TITLE_CHANGED = 0;
        public static int TYPE_ACCESSIBILITY_OVERLAY = 0;
        public static int TYPE_APPLICATION = 0;
        public static int TYPE_APPLICATION_ATTACHED_DIALOG = 0;
        public static int TYPE_APPLICATION_MEDIA = 0;
        public static int TYPE_APPLICATION_OVERLAY = 0;
        public static int TYPE_APPLICATION_PANEL = 0;
        public static int TYPE_APPLICATION_STARTING = 0;
        public static int TYPE_APPLICATION_SUB_PANEL = 0;
        public static int TYPE_BASE_APPLICATION = 0;
        public static int TYPE_CHANGED = 0;
        public static int TYPE_DRAWN_APPLICATION = 0;
        public static int TYPE_INPUT_METHOD = 0;
        public static int TYPE_INPUT_METHOD_DIALOG = 0;
        public static int TYPE_KEYGUARD_DIALOG = 0;
        public static int TYPE_PHONE = 0;
        public static int TYPE_PRIORITY_PHONE = 0;
        public static int TYPE_PRIVATE_PRESENTATION = 0;
        public static int TYPE_SEARCH_BAR = 0;
        public static int TYPE_STATUS_BAR = 0;
        public static int TYPE_SYSTEM_ALERT = 0;
        public static int TYPE_SYSTEM_DIALOG = 0;
        public static int TYPE_SYSTEM_ERROR = 0;
        public static int TYPE_SYSTEM_OVERLAY = 0;
        public static int TYPE_TOAST = 0;
        public static int TYPE_WALLPAPER = 0;
        public void setBlurBehindRadius(int p0){}
        public void setColorMode(int p0){}
        public void setFitInsetsIgnoringVisibility(boolean p0){}
        public void setFitInsetsSides(int p0){}
        public void setFitInsetsTypes(int p0){}
        public void writeToParcel(Parcel p0, int p1){}
    }
    void removeViewImmediate(View p0);
}
