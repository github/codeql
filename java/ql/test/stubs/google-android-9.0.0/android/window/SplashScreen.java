// Generated automatically from android.window.SplashScreen for testing purposes

package android.window;

import android.window.SplashScreenView;

public interface SplashScreen
{
    static public interface OnExitAnimationListener
    {
        void onSplashScreenExit(SplashScreenView p0);
    }
    void clearOnExitAnimationListener();
    void setOnExitAnimationListener(SplashScreen.OnExitAnimationListener p0);
    void setSplashScreenTheme(int p0);
}
