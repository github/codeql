// Generated automatically from android.view.textclassifier.TextLinks for testing purposes

package android.view.textclassifier;

import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import android.text.Spannable;
import android.text.style.ClickableSpan;
import android.view.View;
import java.util.Collection;
import java.util.function.Function;

public class TextLinks implements Parcelable
{
    protected TextLinks() {}
    public Bundle getExtras(){ return null; }
    public CharSequence getText(){ return null; }
    public Collection<TextLinks.TextLink> getLinks(){ return null; }
    public String toString(){ return null; }
    public int apply(Spannable p0, int p1, Function<TextLinks.TextLink, TextLinks.TextLinkSpan> p2){ return 0; }
    public int describeContents(){ return 0; }
    public static Parcelable.Creator<TextLinks> CREATOR = null;
    public static int APPLY_STRATEGY_IGNORE = 0;
    public static int APPLY_STRATEGY_REPLACE = 0;
    public static int STATUS_DIFFERENT_TEXT = 0;
    public static int STATUS_LINKS_APPLIED = 0;
    public static int STATUS_NO_LINKS_APPLIED = 0;
    public static int STATUS_NO_LINKS_FOUND = 0;
    public static int STATUS_UNSUPPORTED_CHARACTER = 0;
    public void writeToParcel(Parcel p0, int p1){}
    static public class TextLink implements Parcelable
    {
        protected TextLink() {}
        public Bundle getExtras(){ return null; }
        public String getEntity(int p0){ return null; }
        public String toString(){ return null; }
        public float getConfidenceScore(String p0){ return 0; }
        public int describeContents(){ return 0; }
        public int getEnd(){ return 0; }
        public int getEntityCount(){ return 0; }
        public int getStart(){ return 0; }
        public static Parcelable.Creator<TextLinks.TextLink> CREATOR = null;
        public void writeToParcel(Parcel p0, int p1){}
    }
    static public class TextLinkSpan extends ClickableSpan
    {
        protected TextLinkSpan() {}
        public TextLinkSpan(TextLinks.TextLink p0){}
        public final TextLinks.TextLink getTextLink(){ return null; }
        public void onClick(View p0){}
    }
}
