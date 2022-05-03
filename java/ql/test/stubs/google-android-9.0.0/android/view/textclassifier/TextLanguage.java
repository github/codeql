// Generated automatically from android.view.textclassifier.TextLanguage for testing purposes

package android.view.textclassifier;

import android.icu.util.ULocale;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;

public class TextLanguage implements Parcelable
{
    protected TextLanguage() {}
    public Bundle getExtras(){ return null; }
    public String getId(){ return null; }
    public String toString(){ return null; }
    public ULocale getLocale(int p0){ return null; }
    public float getConfidenceScore(ULocale p0){ return 0; }
    public int describeContents(){ return 0; }
    public int getLocaleHypothesisCount(){ return 0; }
    public static Parcelable.Creator<TextLanguage> CREATOR = null;
    public void writeToParcel(Parcel p0, int p1){}
    static public class Request implements Parcelable
    {
        protected Request() {}
        public Bundle getExtras(){ return null; }
        public CharSequence getText(){ return null; }
        public String getCallingPackageName(){ return null; }
        public int describeContents(){ return 0; }
        public static Parcelable.Creator<TextLanguage.Request> CREATOR = null;
        public void writeToParcel(Parcel p0, int p1){}
    }
}
