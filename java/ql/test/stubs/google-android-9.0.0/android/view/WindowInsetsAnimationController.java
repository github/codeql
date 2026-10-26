// Generated automatically from android.view.WindowInsetsAnimationController for testing purposes

package android.view;

import android.graphics.Insets;

public interface WindowInsetsAnimationController
{
    Insets getCurrentInsets();
    Insets getHiddenStateInsets();
    Insets getShownStateInsets();
    boolean isCancelled();
    boolean isFinished();
    default boolean isReady(){ return false; }
    float getCurrentAlpha();
    float getCurrentFraction();
    int getTypes();
    void finish(boolean p0);
    void setInsetsAndAlpha(Insets p0, float p1, float p2);
}
