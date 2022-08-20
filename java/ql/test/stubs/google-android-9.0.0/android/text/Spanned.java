// Generated automatically from android.text.Spanned for testing purposes

package android.text;


public interface Spanned extends CharSequence
{
    <T> T[] getSpans(int p0, int p1, Class<T> p2);
    int getSpanEnd(Object p0);
    int getSpanFlags(Object p0);
    int getSpanStart(Object p0);
    int nextSpanTransition(int p0, int p1, Class p2);
    static int SPAN_COMPOSING = 0;
    static int SPAN_EXCLUSIVE_EXCLUSIVE = 0;
    static int SPAN_EXCLUSIVE_INCLUSIVE = 0;
    static int SPAN_INCLUSIVE_EXCLUSIVE = 0;
    static int SPAN_INCLUSIVE_INCLUSIVE = 0;
    static int SPAN_INTERMEDIATE = 0;
    static int SPAN_MARK_MARK = 0;
    static int SPAN_MARK_POINT = 0;
    static int SPAN_PARAGRAPH = 0;
    static int SPAN_POINT_MARK = 0;
    static int SPAN_POINT_MARK_MASK = 0;
    static int SPAN_POINT_POINT = 0;
    static int SPAN_PRIORITY = 0;
    static int SPAN_PRIORITY_SHIFT = 0;
    static int SPAN_USER = 0;
    static int SPAN_USER_SHIFT = 0;
}
