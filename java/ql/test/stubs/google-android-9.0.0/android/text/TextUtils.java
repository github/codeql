// Generated automatically from android.text.TextUtils for testing purposes

package android.text;

import android.content.Context;
import android.os.Parcel;
import android.os.Parcelable;
import android.text.Spannable;
import android.text.Spanned;
import android.text.TextPaint;
import android.util.Printer;
import java.util.List;
import java.util.Locale;
import java.util.regex.Pattern;

public class TextUtils
{
    protected TextUtils() {}
    public static CharSequence commaEllipsize(CharSequence p0, TextPaint p1, float p2, String p3, String p4){ return null; }
    public static CharSequence concat(CharSequence... p0){ return null; }
    public static CharSequence ellipsize(CharSequence p0, TextPaint p1, float p2, TextUtils.TruncateAt p3){ return null; }
    public static CharSequence ellipsize(CharSequence p0, TextPaint p1, float p2, TextUtils.TruncateAt p3, boolean p4, TextUtils.EllipsizeCallback p5){ return null; }
    public static CharSequence expandTemplate(CharSequence p0, CharSequence... p1){ return null; }
    public static CharSequence getReverse(CharSequence p0, int p1, int p2){ return null; }
    public static CharSequence listEllipsize(Context p0, List<CharSequence> p1, String p2, TextPaint p3, float p4, int p5){ return null; }
    public static CharSequence makeSafeForPresentation(String p0, int p1, float p2, int p3){ return null; }
    public static CharSequence replace(CharSequence p0, String[] p1, CharSequence[] p2){ return null; }
    public static CharSequence stringOrSpannedString(CharSequence p0){ return null; }
    public static Parcelable.Creator<CharSequence> CHAR_SEQUENCE_CREATOR = null;
    public static String htmlEncode(String p0){ return null; }
    public static String join(CharSequence p0, Iterable p1){ return null; }
    public static String join(CharSequence p0, Object[] p1){ return null; }
    public static String substring(CharSequence p0, int p1, int p2){ return null; }
    public static String[] split(String p0, Pattern p1){ return null; }
    public static String[] split(String p0, String p1){ return null; }
    public static boolean equals(CharSequence p0, CharSequence p1){ return false; }
    public static boolean isDigitsOnly(CharSequence p0){ return false; }
    public static boolean isEmpty(CharSequence p0){ return false; }
    public static boolean isGraphic(CharSequence p0){ return false; }
    public static boolean isGraphic(char p0){ return false; }
    public static boolean regionMatches(CharSequence p0, int p1, CharSequence p2, int p3, int p4){ return false; }
    public static int CAP_MODE_CHARACTERS = 0;
    public static int CAP_MODE_SENTENCES = 0;
    public static int CAP_MODE_WORDS = 0;
    public static int SAFE_STRING_FLAG_FIRST_LINE = 0;
    public static int SAFE_STRING_FLAG_SINGLE_LINE = 0;
    public static int SAFE_STRING_FLAG_TRIM = 0;
    public static int getCapsMode(CharSequence p0, int p1, int p2){ return 0; }
    public static int getLayoutDirectionFromLocale(Locale p0){ return 0; }
    public static int getOffsetAfter(CharSequence p0, int p1){ return 0; }
    public static int getOffsetBefore(CharSequence p0, int p1){ return 0; }
    public static int getTrimmedLength(CharSequence p0){ return 0; }
    public static int indexOf(CharSequence p0, CharSequence p1){ return 0; }
    public static int indexOf(CharSequence p0, CharSequence p1, int p2){ return 0; }
    public static int indexOf(CharSequence p0, CharSequence p1, int p2, int p3){ return 0; }
    public static int indexOf(CharSequence p0, char p1){ return 0; }
    public static int indexOf(CharSequence p0, char p1, int p2){ return 0; }
    public static int indexOf(CharSequence p0, char p1, int p2, int p3){ return 0; }
    public static int lastIndexOf(CharSequence p0, char p1){ return 0; }
    public static int lastIndexOf(CharSequence p0, char p1, int p2){ return 0; }
    public static int lastIndexOf(CharSequence p0, char p1, int p2, int p3){ return 0; }
    public static void copySpansFrom(Spanned p0, int p1, int p2, Class p3, Spannable p4, int p5){}
    public static void dumpSpans(CharSequence p0, Printer p1, String p2){}
    public static void getChars(CharSequence p0, int p1, int p2, char[] p3, int p4){}
    public static void writeToParcel(CharSequence p0, Parcel p1, int p2){}
    static public enum TruncateAt
    {
        END, MARQUEE, MIDDLE, START;
        private TruncateAt() {}
    }
    static public interface EllipsizeCallback
    {
        void ellipsized(int p0, int p1);
    }
}
