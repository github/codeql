// Generated automatically from android.content.res.Resources for testing purposes

package android.content.res;

import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.content.res.ColorStateList;
import android.content.res.Configuration;
import android.content.res.TypedArray;
import android.content.res.XmlResourceParser;
import android.content.res.loader.ResourcesLoader;
import android.graphics.Movie;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import java.io.InputStream;

public class Resources
{
    protected Resources() {}
    public AssetFileDescriptor openRawResourceFd(int p0){ return null; }
    public CharSequence getQuantityText(int p0, int p1){ return null; }
    public CharSequence getText(int p0){ return null; }
    public CharSequence getText(int p0, CharSequence p1){ return null; }
    public CharSequence[] getTextArray(int p0){ return null; }
    public ColorStateList getColorStateList(int p0){ return null; }
    public ColorStateList getColorStateList(int p0, Resources.Theme p1){ return null; }
    public Configuration getConfiguration(){ return null; }
    public DisplayMetrics getDisplayMetrics(){ return null; }
    public Drawable getDrawable(int p0){ return null; }
    public Drawable getDrawable(int p0, Resources.Theme p1){ return null; }
    public Drawable getDrawableForDensity(int p0, int p1){ return null; }
    public Drawable getDrawableForDensity(int p0, int p1, Resources.Theme p2){ return null; }
    public InputStream openRawResource(int p0){ return null; }
    public InputStream openRawResource(int p0, TypedValue p1){ return null; }
    public Movie getMovie(int p0){ return null; }
    public Resources(AssetManager p0, DisplayMetrics p1, Configuration p2){}
    public String getQuantityString(int p0, int p1){ return null; }
    public String getQuantityString(int p0, int p1, Object... p2){ return null; }
    public String getResourceEntryName(int p0){ return null; }
    public String getResourceName(int p0){ return null; }
    public String getResourcePackageName(int p0){ return null; }
    public String getResourceTypeName(int p0){ return null; }
    public String getString(int p0){ return null; }
    public String getString(int p0, Object... p1){ return null; }
    public String[] getStringArray(int p0){ return null; }
    public TypedArray obtainAttributes(AttributeSet p0, int[] p1){ return null; }
    public TypedArray obtainTypedArray(int p0){ return null; }
    public Typeface getFont(int p0){ return null; }
    public XmlResourceParser getAnimation(int p0){ return null; }
    public XmlResourceParser getLayout(int p0){ return null; }
    public XmlResourceParser getXml(int p0){ return null; }
    public boolean getBoolean(int p0){ return false; }
    public class Theme
    {
        protected Theme() {}
        public Drawable getDrawable(int p0){ return null; }
        public Resources getResources(){ return null; }
        public TypedArray obtainStyledAttributes(AttributeSet p0, int[] p1, int p2, int p3){ return null; }
        public TypedArray obtainStyledAttributes(int p0, int[] p1){ return null; }
        public TypedArray obtainStyledAttributes(int[] p0){ return null; }
        public boolean resolveAttribute(int p0, TypedValue p1, boolean p2){ return false; }
        public int getChangingConfigurations(){ return 0; }
        public int getExplicitStyle(AttributeSet p0){ return 0; }
        public int[] getAttributeResolutionStack(int p0, int p1, int p2){ return null; }
        public void applyStyle(int p0, boolean p1){}
        public void dump(int p0, String p1, String p2){}
        public void rebase(){}
        public void setTo(Resources.Theme p0){}
    }
    public final AssetManager getAssets(){ return null; }
    public final Resources.Theme newTheme(){ return null; }
    public final void finishPreloading(){}
    public final void flushLayoutCache(){}
    public float getDimension(int p0){ return 0; }
    public float getFloat(int p0){ return 0; }
    public float getFraction(int p0, int p1, int p2){ return 0; }
    public int getColor(int p0){ return 0; }
    public int getColor(int p0, Resources.Theme p1){ return 0; }
    public int getDimensionPixelOffset(int p0){ return 0; }
    public int getDimensionPixelSize(int p0){ return 0; }
    public int getIdentifier(String p0, String p1, String p2){ return 0; }
    public int getInteger(int p0){ return 0; }
    public int[] getIntArray(int p0){ return null; }
    public static Resources getSystem(){ return null; }
    public static int ID_NULL = 0;
    public static int getAttributeSetSourceResId(AttributeSet p0){ return 0; }
    public void addLoaders(ResourcesLoader... p0){}
    public void getValue(String p0, TypedValue p1, boolean p2){}
    public void getValue(int p0, TypedValue p1, boolean p2){}
    public void getValueForDensity(int p0, int p1, TypedValue p2, boolean p3){}
    public void parseBundleExtra(String p0, AttributeSet p1, Bundle p2){}
    public void parseBundleExtras(XmlResourceParser p0, Bundle p1){}
    public void removeLoaders(ResourcesLoader... p0){}
    public void updateConfiguration(Configuration p0, DisplayMetrics p1){}
    static public class NotFoundException extends RuntimeException
    {
        public NotFoundException(){}
        public NotFoundException(String p0){}
        public NotFoundException(String p0, Exception p1){}
    }
}
