// Generated automatically from android.graphics.drawable.Drawable for testing purposes

package android.graphics.drawable;

import android.content.res.ColorStateList;
import android.content.res.Resources;
import android.graphics.BitmapFactory;
import android.graphics.BlendMode;
import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.Insets;
import android.graphics.Outline;
import android.graphics.PorterDuff;
import android.graphics.Rect;
import android.graphics.Region;
import android.util.AttributeSet;
import android.util.TypedValue;
import java.io.InputStream;
import org.xmlpull.v1.XmlPullParser;

abstract public class Drawable
{
    abstract static public class ConstantState
    {
        public ConstantState(){}
        public Drawable newDrawable(Resources p0){ return null; }
        public Drawable newDrawable(Resources p0, Resources.Theme p1){ return null; }
        public abstract Drawable newDrawable();
        public abstract int getChangingConfigurations();
        public boolean canApplyTheme(){ return false; }
    }
    protected boolean onLevelChange(int p0){ return false; }
    protected boolean onStateChange(int[] p0){ return false; }
    protected void onBoundsChange(Rect p0){}
    public ColorFilter getColorFilter(){ return null; }
    public Drawable getCurrent(){ return null; }
    public Drawable mutate(){ return null; }
    public Drawable(){}
    public Drawable.Callback getCallback(){ return null; }
    public Drawable.ConstantState getConstantState(){ return null; }
    public Insets getOpticalInsets(){ return null; }
    public Rect getDirtyBounds(){ return null; }
    public Region getTransparentRegion(){ return null; }
    public abstract int getOpacity();
    public abstract void draw(Canvas p0);
    public abstract void setAlpha(int p0);
    public abstract void setColorFilter(ColorFilter p0);
    public boolean canApplyTheme(){ return false; }
    public boolean getPadding(Rect p0){ return false; }
    public boolean isAutoMirrored(){ return false; }
    public boolean isFilterBitmap(){ return false; }
    public boolean isProjected(){ return false; }
    public boolean isStateful(){ return false; }
    public boolean onLayoutDirectionChanged(int p0){ return false; }
    public boolean setState(int[] p0){ return false; }
    public boolean setVisible(boolean p0, boolean p1){ return false; }
    public final Rect copyBounds(){ return null; }
    public final Rect getBounds(){ return null; }
    public final boolean isVisible(){ return false; }
    public final boolean setLayoutDirection(int p0){ return false; }
    public final boolean setLevel(int p0){ return false; }
    public final int getLevel(){ return 0; }
    public final void copyBounds(Rect p0){}
    public final void setCallback(Drawable.Callback p0){}
    public int getAlpha(){ return 0; }
    public int getChangingConfigurations(){ return 0; }
    public int getIntrinsicHeight(){ return 0; }
    public int getIntrinsicWidth(){ return 0; }
    public int getLayoutDirection(){ return 0; }
    public int getMinimumHeight(){ return 0; }
    public int getMinimumWidth(){ return 0; }
    public int[] getState(){ return null; }
    public static Drawable createFromPath(String p0){ return null; }
    public static Drawable createFromResourceStream(Resources p0, TypedValue p1, InputStream p2, String p3){ return null; }
    public static Drawable createFromResourceStream(Resources p0, TypedValue p1, InputStream p2, String p3, BitmapFactory.Options p4){ return null; }
    public static Drawable createFromStream(InputStream p0, String p1){ return null; }
    public static Drawable createFromXml(Resources p0, XmlPullParser p1){ return null; }
    public static Drawable createFromXml(Resources p0, XmlPullParser p1, Resources.Theme p2){ return null; }
    public static Drawable createFromXmlInner(Resources p0, XmlPullParser p1, AttributeSet p2){ return null; }
    public static Drawable createFromXmlInner(Resources p0, XmlPullParser p1, AttributeSet p2, Resources.Theme p3){ return null; }
    public static int resolveOpacity(int p0, int p1){ return 0; }
    public void applyTheme(Resources.Theme p0){}
    public void clearColorFilter(){}
    public void getHotspotBounds(Rect p0){}
    public void getOutline(Outline p0){}
    public void inflate(Resources p0, XmlPullParser p1, AttributeSet p2){}
    public void inflate(Resources p0, XmlPullParser p1, AttributeSet p2, Resources.Theme p3){}
    public void invalidateSelf(){}
    public void jumpToCurrentState(){}
    public void scheduleSelf(Runnable p0, long p1){}
    public void setAutoMirrored(boolean p0){}
    public void setBounds(Rect p0){}
    public void setBounds(int p0, int p1, int p2, int p3){}
    public void setChangingConfigurations(int p0){}
    public void setColorFilter(int p0, PorterDuff.Mode p1){}
    public void setDither(boolean p0){}
    public void setFilterBitmap(boolean p0){}
    public void setHotspot(float p0, float p1){}
    public void setHotspotBounds(int p0, int p1, int p2, int p3){}
    public void setTint(int p0){}
    public void setTintBlendMode(BlendMode p0){}
    public void setTintList(ColorStateList p0){}
    public void setTintMode(PorterDuff.Mode p0){}
    public void unscheduleSelf(Runnable p0){}
    static public interface Callback
    {
        void invalidateDrawable(Drawable p0);
        void scheduleDrawable(Drawable p0, Runnable p1, long p2);
        void unscheduleDrawable(Drawable p0, Runnable p1);
    }
}
