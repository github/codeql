// Generated automatically from android.view.WindowInsetsController for testing purposes

package android.view;

import android.os.CancellationSignal;
import android.view.WindowInsetsAnimationControlListener;
import android.view.animation.Interpolator;

public interface WindowInsetsController
{
    int getSystemBarsAppearance();
    int getSystemBarsBehavior();
    static int APPEARANCE_LIGHT_NAVIGATION_BARS = 0;
    static int APPEARANCE_LIGHT_STATUS_BARS = 0;
    static int BEHAVIOR_DEFAULT = 0;
    static int BEHAVIOR_SHOW_BARS_BY_SWIPE = 0;
    static int BEHAVIOR_SHOW_BARS_BY_TOUCH = 0;
    static int BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE = 0;
    static public interface OnControllableInsetsChangedListener
    {
        void onControllableInsetsChanged(WindowInsetsController p0, int p1);
    }
    void addOnControllableInsetsChangedListener(WindowInsetsController.OnControllableInsetsChangedListener p0);
    void controlWindowInsetsAnimation(int p0, long p1, Interpolator p2, CancellationSignal p3, WindowInsetsAnimationControlListener p4);
    void hide(int p0);
    void removeOnControllableInsetsChangedListener(WindowInsetsController.OnControllableInsetsChangedListener p0);
    void setSystemBarsAppearance(int p0, int p1);
    void setSystemBarsBehavior(int p0);
    void show(int p0);
}
