// Generated automatically from android.widget.RemoteViews for testing purposes

package android.widget;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.res.ColorStateList;
import android.graphics.Bitmap;
import android.graphics.BlendMode;
import android.graphics.drawable.Icon;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.SizeF;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import java.util.Map;

public class RemoteViews implements LayoutInflater.Filter, Parcelable
{
    protected RemoteViews() {}
    public RemoteViews clone(){ return null; }
    public RemoteViews(Map<SizeF, RemoteViews> p0){}
    public RemoteViews(Parcel p0){}
    public RemoteViews(RemoteViews p0){}
    public RemoteViews(RemoteViews p0, RemoteViews p1){}
    public RemoteViews(String p0, int p1){}
    public RemoteViews(String p0, int p1, int p2){}
    public String getPackage(){ return null; }
    public View apply(Context p0, ViewGroup p1){ return null; }
    public boolean onLoadClass(Class p0){ return false; }
    public int describeContents(){ return 0; }
    public int getLayoutId(){ return 0; }
    public int getViewId(){ return 0; }
    public static Parcelable.Creator<RemoteViews> CREATOR = null;
    public static String EXTRA_CHECKED = null;
    public static String EXTRA_SHARED_ELEMENT_BOUNDS = null;
    public static int MARGIN_BOTTOM = 0;
    public static int MARGIN_END = 0;
    public static int MARGIN_LEFT = 0;
    public static int MARGIN_RIGHT = 0;
    public static int MARGIN_START = 0;
    public static int MARGIN_TOP = 0;
    public void addStableView(int p0, RemoteViews p1, int p2){}
    public void addView(int p0, RemoteViews p1){}
    public void reapply(Context p0, View p1){}
    public void removeAllViews(int p0){}
    public void setAccessibilityTraversalAfter(int p0, int p1){}
    public void setAccessibilityTraversalBefore(int p0, int p1){}
    public void setBitmap(int p0, String p1, Bitmap p2){}
    public void setBlendMode(int p0, String p1, BlendMode p2){}
    public void setBoolean(int p0, String p1, boolean p2){}
    public void setBundle(int p0, String p1, Bundle p2){}
    public void setByte(int p0, String p1, byte p2){}
    public void setChar(int p0, String p1, char p2){}
    public void setCharSequence(int p0, String p1, CharSequence p2){}
    public void setCharSequence(int p0, String p1, int p2){}
    public void setCharSequenceAttr(int p0, String p1, int p2){}
    public void setChronometer(int p0, long p1, String p2, boolean p3){}
    public void setChronometerCountDown(int p0, boolean p1){}
    public void setColor(int p0, String p1, int p2){}
    public void setColorAttr(int p0, String p1, int p2){}
    public void setColorInt(int p0, String p1, int p2, int p3){}
    public void setColorStateList(int p0, String p1, ColorStateList p2){}
    public void setColorStateList(int p0, String p1, ColorStateList p2, ColorStateList p3){}
    public void setColorStateList(int p0, String p1, int p2){}
    public void setColorStateListAttr(int p0, String p1, int p2){}
    public void setCompoundButtonChecked(int p0, boolean p1){}
    public void setContentDescription(int p0, CharSequence p1){}
    public void setDisplayedChild(int p0, int p1){}
    public void setDouble(int p0, String p1, double p2){}
    public void setEmptyView(int p0, int p1){}
    public void setFloat(int p0, String p1, float p2){}
    public void setFloatDimen(int p0, String p1, float p2, int p3){}
    public void setFloatDimen(int p0, String p1, int p2){}
    public void setFloatDimenAttr(int p0, String p1, int p2){}
    public void setIcon(int p0, String p1, Icon p2){}
    public void setIcon(int p0, String p1, Icon p2, Icon p3){}
    public void setImageViewBitmap(int p0, Bitmap p1){}
    public void setImageViewIcon(int p0, Icon p1){}
    public void setImageViewResource(int p0, int p1){}
    public void setImageViewUri(int p0, Uri p1){}
    public void setInt(int p0, String p1, int p2){}
    public void setIntDimen(int p0, String p1, float p2, int p3){}
    public void setIntDimen(int p0, String p1, int p2){}
    public void setIntDimenAttr(int p0, String p1, int p2){}
    public void setIntent(int p0, String p1, Intent p2){}
    public void setLabelFor(int p0, int p1){}
    public void setLightBackgroundLayoutId(int p0){}
    public void setLong(int p0, String p1, long p2){}
    public void setOnCheckedChangeResponse(int p0, RemoteViews.RemoteResponse p1){}
    public void setOnClickFillInIntent(int p0, Intent p1){}
    public void setOnClickPendingIntent(int p0, PendingIntent p1){}
    public void setOnClickResponse(int p0, RemoteViews.RemoteResponse p1){}
    public void setPendingIntentTemplate(int p0, PendingIntent p1){}
    public void setProgressBar(int p0, int p1, int p2, boolean p3){}
    public void setRadioGroupChecked(int p0, int p1){}
    public void setRelativeScrollPosition(int p0, int p1){}
    public void setRemoteAdapter(int p0, Intent p1){}
    public void setRemoteAdapter(int p0, RemoteViews.RemoteCollectionItems p1){}
    public void setRemoteAdapter(int p0, int p1, Intent p2){}
    public void setScrollPosition(int p0, int p1){}
    public void setShort(int p0, String p1, short p2){}
    public void setString(int p0, String p1, String p2){}
    public void setTextColor(int p0, int p1){}
    public void setTextViewCompoundDrawables(int p0, int p1, int p2, int p3, int p4){}
    public void setTextViewCompoundDrawablesRelative(int p0, int p1, int p2, int p3, int p4){}
    public void setTextViewText(int p0, CharSequence p1){}
    public void setTextViewTextSize(int p0, int p1, float p2){}
    public void setUri(int p0, String p1, Uri p2){}
    public void setViewLayoutHeight(int p0, float p1, int p2){}
    public void setViewLayoutHeightAttr(int p0, int p1){}
    public void setViewLayoutHeightDimen(int p0, int p1){}
    public void setViewLayoutMargin(int p0, int p1, float p2, int p3){}
    public void setViewLayoutMarginAttr(int p0, int p1, int p2){}
    public void setViewLayoutMarginDimen(int p0, int p1, int p2){}
    public void setViewLayoutWidth(int p0, float p1, int p2){}
    public void setViewLayoutWidthAttr(int p0, int p1){}
    public void setViewLayoutWidthDimen(int p0, int p1){}
    public void setViewOutlinePreferredRadius(int p0, float p1, int p2){}
    public void setViewOutlinePreferredRadiusAttr(int p0, int p1){}
    public void setViewOutlinePreferredRadiusDimen(int p0, int p1){}
    public void setViewPadding(int p0, int p1, int p2, int p3, int p4){}
    public void setViewVisibility(int p0, int p1){}
    public void showNext(int p0){}
    public void showPrevious(int p0){}
    public void writeToParcel(Parcel p0, int p1){}
    static public class RemoteCollectionItems implements Parcelable
    {
        public RemoteViews getItemView(int p0){ return null; }
        public boolean hasStableIds(){ return false; }
        public int describeContents(){ return 0; }
        public int getItemCount(){ return 0; }
        public int getViewTypeCount(){ return 0; }
        public long getItemId(int p0){ return 0; }
        public static Parcelable.Creator<RemoteViews.RemoteCollectionItems> CREATOR = null;
        public void writeToParcel(Parcel p0, int p1){}
    }
    static public class RemoteResponse
    {
        public RemoteResponse(){}
        public RemoteViews.RemoteResponse addSharedElement(int p0, String p1){ return null; }
        public static RemoteViews.RemoteResponse fromFillInIntent(Intent p0){ return null; }
        public static RemoteViews.RemoteResponse fromPendingIntent(PendingIntent p0){ return null; }
    }
}
