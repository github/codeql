// Generated automatically from android.view.LayoutInflater for testing purposes

package android.view;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import org.xmlpull.v1.XmlPullParser;

abstract public class LayoutInflater
{
    protected LayoutInflater() {}
    protected LayoutInflater(Context p0){}
    protected LayoutInflater(LayoutInflater p0, Context p1){}
    protected View onCreateView(String p0, AttributeSet p1){ return null; }
    protected View onCreateView(View p0, String p1, AttributeSet p2){ return null; }
    public Context getContext(){ return null; }
    public LayoutInflater.Filter getFilter(){ return null; }
    public View inflate(XmlPullParser p0, ViewGroup p1){ return null; }
    public View inflate(XmlPullParser p0, ViewGroup p1, boolean p2){ return null; }
    public View inflate(int p0, ViewGroup p1){ return null; }
    public View inflate(int p0, ViewGroup p1, boolean p2){ return null; }
    public View onCreateView(Context p0, View p1, String p2, AttributeSet p3){ return null; }
    public abstract LayoutInflater cloneInContext(Context p0);
    public final LayoutInflater.Factory getFactory(){ return null; }
    public final LayoutInflater.Factory2 getFactory2(){ return null; }
    public final View createView(Context p0, String p1, String p2, AttributeSet p3){ return null; }
    public final View createView(String p0, String p1, AttributeSet p2){ return null; }
    public static LayoutInflater from(Context p0){ return null; }
    public void setFactory(LayoutInflater.Factory p0){}
    public void setFactory2(LayoutInflater.Factory2 p0){}
    public void setFilter(LayoutInflater.Filter p0){}
    static public interface Factory
    {
        View onCreateView(String p0, Context p1, AttributeSet p2);
    }
    static public interface Factory2 extends LayoutInflater.Factory
    {
        View onCreateView(View p0, String p1, Context p2, AttributeSet p3);
    }
    static public interface Filter
    {
        boolean onLoadClass(Class p0);
    }
}
