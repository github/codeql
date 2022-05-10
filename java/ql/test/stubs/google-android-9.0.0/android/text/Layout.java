// Generated automatically from android.text.Layout for testing purposes

package android.text;

import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Rect;
import android.text.TextPaint;

abstract public class Layout
{
    protected Layout() {}
    protected Layout(CharSequence p0, TextPaint p1, int p2, Layout.Alignment p3, float p4, float p5){}
    protected final boolean isSpanned(){ return false; }
    public abstract Layout.Directions getLineDirections(int p0);
    public abstract boolean getLineContainsTab(int p0);
    public abstract int getBottomPadding();
    public abstract int getEllipsisCount(int p0);
    public abstract int getEllipsisStart(int p0);
    public abstract int getLineCount();
    public abstract int getLineDescent(int p0);
    public abstract int getLineStart(int p0);
    public abstract int getLineTop(int p0);
    public abstract int getParagraphDirection(int p0);
    public abstract int getTopPadding();
    public boolean isRtlCharAt(int p0){ return false; }
    public final CharSequence getText(){ return null; }
    public final Layout.Alignment getAlignment(){ return null; }
    public final Layout.Alignment getParagraphAlignment(int p0){ return null; }
    public final TextPaint getPaint(){ return null; }
    public final float getSpacingAdd(){ return 0; }
    public final float getSpacingMultiplier(){ return 0; }
    public final int getLineAscent(int p0){ return 0; }
    public final int getLineBaseline(int p0){ return 0; }
    public final int getLineBottom(int p0){ return 0; }
    public final int getLineEnd(int p0){ return 0; }
    public final int getParagraphLeft(int p0){ return 0; }
    public final int getParagraphRight(int p0){ return 0; }
    public final int getWidth(){ return 0; }
    public final void increaseWidthTo(int p0){}
    public float getLineLeft(int p0){ return 0; }
    public float getLineMax(int p0){ return 0; }
    public float getLineRight(int p0){ return 0; }
    public float getLineWidth(int p0){ return 0; }
    public float getPrimaryHorizontal(int p0){ return 0; }
    public float getSecondaryHorizontal(int p0){ return 0; }
    public int getEllipsizedWidth(){ return 0; }
    public int getHeight(){ return 0; }
    public int getLineBounds(int p0, Rect p1){ return 0; }
    public int getLineForOffset(int p0){ return 0; }
    public int getLineForVertical(int p0){ return 0; }
    public int getLineVisibleEnd(int p0){ return 0; }
    public int getOffsetForHorizontal(int p0, float p1){ return 0; }
    public int getOffsetToLeftOf(int p0){ return 0; }
    public int getOffsetToRightOf(int p0){ return 0; }
    public static float DEFAULT_LINESPACING_ADDITION = 0;
    public static float DEFAULT_LINESPACING_MULTIPLIER = 0;
    public static float getDesiredWidth(CharSequence p0, TextPaint p1){ return 0; }
    public static float getDesiredWidth(CharSequence p0, int p1, int p2, TextPaint p3){ return 0; }
    public static int BREAK_STRATEGY_BALANCED = 0;
    public static int BREAK_STRATEGY_HIGH_QUALITY = 0;
    public static int BREAK_STRATEGY_SIMPLE = 0;
    public static int DIR_LEFT_TO_RIGHT = 0;
    public static int DIR_RIGHT_TO_LEFT = 0;
    public static int HYPHENATION_FREQUENCY_FULL = 0;
    public static int HYPHENATION_FREQUENCY_NONE = 0;
    public static int HYPHENATION_FREQUENCY_NORMAL = 0;
    public static int JUSTIFICATION_MODE_INTER_WORD = 0;
    public static int JUSTIFICATION_MODE_NONE = 0;
    public void draw(Canvas p0){}
    public void draw(Canvas p0, Path p1, Paint p2, int p3){}
    public void getCursorPath(int p0, Path p1, CharSequence p2){}
    public void getSelectionPath(int p0, int p1, Path p2){}
    static public class Directions
    {
    }
    static public enum Alignment
    {
        ALIGN_CENTER, ALIGN_NORMAL, ALIGN_OPPOSITE;
        private Alignment() {}
    }
}
