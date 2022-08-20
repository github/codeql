// Generated automatically from android.view.animation.LayoutAnimationController for testing purposes

package android.view.animation;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.Interpolator;
import java.util.Random;

public class LayoutAnimationController
{
    protected LayoutAnimationController() {}
    protected Animation mAnimation = null;
    protected Interpolator mInterpolator = null;
    protected Random mRandomizer = null;
    protected int getTransformedIndex(LayoutAnimationController.AnimationParameters p0){ return 0; }
    protected long getDelayForView(View p0){ return 0; }
    public Animation getAnimation(){ return null; }
    public Interpolator getInterpolator(){ return null; }
    public LayoutAnimationController(Animation p0){}
    public LayoutAnimationController(Animation p0, float p1){}
    public LayoutAnimationController(Context p0, AttributeSet p1){}
    public boolean isDone(){ return false; }
    public boolean willOverlap(){ return false; }
    public final Animation getAnimationForView(View p0){ return null; }
    public float getDelay(){ return 0; }
    public int getOrder(){ return 0; }
    public static int ORDER_NORMAL = 0;
    public static int ORDER_RANDOM = 0;
    public static int ORDER_REVERSE = 0;
    public void setAnimation(Animation p0){}
    public void setAnimation(Context p0, int p1){}
    public void setDelay(float p0){}
    public void setInterpolator(Context p0, int p1){}
    public void setInterpolator(Interpolator p0){}
    public void setOrder(int p0){}
    public void start(){}
    static public class AnimationParameters
    {
        public AnimationParameters(){}
        public int count = 0;
        public int index = 0;
    }
}
