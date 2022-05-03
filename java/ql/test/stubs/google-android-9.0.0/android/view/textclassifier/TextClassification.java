// Generated automatically from android.view.textclassifier.TextClassification for testing purposes

package android.view.textclassifier;

import android.app.RemoteAction;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.LocaleList;
import android.os.Parcel;
import android.os.Parcelable;
import android.view.View;
import java.time.ZonedDateTime;
import java.util.List;

public class TextClassification implements Parcelable
{
    protected TextClassification() {}
    public Bundle getExtras(){ return null; }
    public CharSequence getLabel(){ return null; }
    public Drawable getIcon(){ return null; }
    public Intent getIntent(){ return null; }
    public List<RemoteAction> getActions(){ return null; }
    public String getEntity(int p0){ return null; }
    public String getId(){ return null; }
    public String getText(){ return null; }
    public String toString(){ return null; }
    public View.OnClickListener getOnClickListener(){ return null; }
    public float getConfidenceScore(String p0){ return 0; }
    public int describeContents(){ return 0; }
    public int getEntityCount(){ return 0; }
    public static Parcelable.Creator<TextClassification> CREATOR = null;
    public void writeToParcel(Parcel p0, int p1){}
    static public class Request implements Parcelable
    {
        protected Request() {}
        public Bundle getExtras(){ return null; }
        public CharSequence getText(){ return null; }
        public LocaleList getDefaultLocales(){ return null; }
        public String getCallingPackageName(){ return null; }
        public ZonedDateTime getReferenceTime(){ return null; }
        public int describeContents(){ return 0; }
        public int getEndIndex(){ return 0; }
        public int getStartIndex(){ return 0; }
        public static Parcelable.Creator<TextClassification.Request> CREATOR = null;
        public void writeToParcel(Parcel p0, int p1){}
    }
}
