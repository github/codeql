// Generated automatically from android.graphics.RecordingCanvas for testing purposes

package android.graphics;

import android.graphics.Bitmap;
import android.graphics.BlendMode;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.NinePatch;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Picture;
import android.graphics.PorterDuff;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.RenderNode;
import android.graphics.fonts.Font;
import android.graphics.text.MeasuredText;

public class RecordingCanvas extends Canvas
{
    protected RecordingCanvas() {}
    public boolean isHardwareAccelerated(){ return false; }
    public boolean isOpaque(){ return false; }
    public final void drawARGB(int p0, int p1, int p2, int p3){}
    public final void drawArc(RectF p0, float p1, float p2, boolean p3, Paint p4){}
    public final void drawArc(float p0, float p1, float p2, float p3, float p4, float p5, boolean p6, Paint p7){}
    public final void drawBitmap(Bitmap p0, Matrix p1, Paint p2){}
    public final void drawBitmap(Bitmap p0, Rect p1, Rect p2, Paint p3){}
    public final void drawBitmap(Bitmap p0, Rect p1, RectF p2, Paint p3){}
    public final void drawBitmap(Bitmap p0, float p1, float p2, Paint p3){}
    public final void drawBitmap(int[] p0, int p1, int p2, float p3, float p4, int p5, int p6, boolean p7, Paint p8){}
    public final void drawBitmap(int[] p0, int p1, int p2, int p3, int p4, int p5, int p6, boolean p7, Paint p8){}
    public final void drawBitmapMesh(Bitmap p0, int p1, int p2, float[] p3, int p4, int[] p5, int p6, Paint p7){}
    public final void drawCircle(float p0, float p1, float p2, Paint p3){}
    public final void drawColor(int p0){}
    public final void drawColor(int p0, BlendMode p1){}
    public final void drawColor(int p0, PorterDuff.Mode p1){}
    public final void drawColor(long p0, BlendMode p1){}
    public final void drawDoubleRoundRect(RectF p0, float p1, float p2, RectF p3, float p4, float p5, Paint p6){}
    public final void drawDoubleRoundRect(RectF p0, float[] p1, RectF p2, float[] p3, Paint p4){}
    public final void drawLine(float p0, float p1, float p2, float p3, Paint p4){}
    public final void drawLines(float[] p0, Paint p1){}
    public final void drawLines(float[] p0, int p1, int p2, Paint p3){}
    public final void drawOval(RectF p0, Paint p1){}
    public final void drawOval(float p0, float p1, float p2, float p3, Paint p4){}
    public final void drawPaint(Paint p0){}
    public final void drawPatch(NinePatch p0, Rect p1, Paint p2){}
    public final void drawPatch(NinePatch p0, RectF p1, Paint p2){}
    public final void drawPath(Path p0, Paint p1){}
    public final void drawPicture(Picture p0){}
    public final void drawPicture(Picture p0, Rect p1){}
    public final void drawPicture(Picture p0, RectF p1){}
    public final void drawPoint(float p0, float p1, Paint p2){}
    public final void drawPoints(float[] p0, Paint p1){}
    public final void drawPoints(float[] p0, int p1, int p2, Paint p3){}
    public final void drawPosText(String p0, float[] p1, Paint p2){}
    public final void drawPosText(char[] p0, int p1, int p2, float[] p3, Paint p4){}
    public final void drawRGB(int p0, int p1, int p2){}
    public final void drawRect(Rect p0, Paint p1){}
    public final void drawRect(RectF p0, Paint p1){}
    public final void drawRect(float p0, float p1, float p2, float p3, Paint p4){}
    public final void drawRoundRect(RectF p0, float p1, float p2, Paint p3){}
    public final void drawRoundRect(float p0, float p1, float p2, float p3, float p4, float p5, Paint p6){}
    public final void drawText(CharSequence p0, int p1, int p2, float p3, float p4, Paint p5){}
    public final void drawText(String p0, float p1, float p2, Paint p3){}
    public final void drawText(String p0, int p1, int p2, float p3, float p4, Paint p5){}
    public final void drawText(char[] p0, int p1, int p2, float p3, float p4, Paint p5){}
    public final void drawTextOnPath(String p0, Path p1, float p2, float p3, Paint p4){}
    public final void drawTextOnPath(char[] p0, int p1, int p2, Path p3, float p4, float p5, Paint p6){}
    public final void drawTextRun(CharSequence p0, int p1, int p2, int p3, int p4, float p5, float p6, boolean p7, Paint p8){}
    public final void drawTextRun(char[] p0, int p1, int p2, int p3, int p4, float p5, float p6, boolean p7, Paint p8){}
    public final void drawVertices(Canvas.VertexMode p0, int p1, float[] p2, int p3, float[] p4, int p5, int[] p6, int p7, short[] p8, int p9, int p10, Paint p11){}
    public int getHeight(){ return 0; }
    public int getMaximumBitmapHeight(){ return 0; }
    public int getMaximumBitmapWidth(){ return 0; }
    public int getWidth(){ return 0; }
    public void disableZ(){}
    public void drawGlyphs(int[] p0, int p1, float[] p2, int p3, int p4, Font p5, Paint p6){}
    public void drawRenderNode(RenderNode p0){}
    public void drawTextRun(MeasuredText p0, int p1, int p2, int p3, int p4, float p5, float p6, boolean p7, Paint p8){}
    public void enableZ(){}
    public void setBitmap(Bitmap p0){}
    public void setDensity(int p0){}
}
