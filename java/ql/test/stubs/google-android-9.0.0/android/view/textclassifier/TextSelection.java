// Generated automatically from android.view.textclassifier.TextSelection for testing purposes

package android.view.textclassifier;

import android.os.Bundle;
import android.os.LocaleList;
import android.os.Parcel;
import android.os.Parcelable;
import android.view.textclassifier.TextClassification;

public class TextSelection implements Parcelable
{
    protected TextSelection() {}
    public Bundle getExtras(){ return null; }
    public String getEntity(int p0){ return null; }
    public String getId(){ return null; }
    public String toString(){ return null; }
    public TextClassification getTextClassification(){ return null; }
    public float getConfidenceScore(String p0){ return 0; }
    public int describeContents(){ return 0; }
    public int getEntityCount(){ return 0; }
    public int getSelectionEndIndex(){ return 0; }
    public int getSelectionStartIndex(){ return 0; }
    public static Parcelable.Creator<TextSelection> CREATOR = null;
    public void writeToParcel(Parcel p0, int p1){}
    static public class Request implements Parcelable
    {
        protected Request() {}
        public Bundle getExtras(){ return null; }
        public CharSequence getText(){ return null; }
        public LocaleList getDefaultLocales(){ return null; }
        public String getCallingPackageName(){ return null; }
        public boolean shouldIncludeTextClassification(){ return false; }
        public int describeContents(){ return 0; }
        public int getEndIndex(){ return 0; }
        public int getStartIndex(){ return 0; }
        public static Parcelable.Creator<TextSelection.Request> CREATOR = null;
        public void writeToParcel(Parcel p0, int p1){}
    }
}
