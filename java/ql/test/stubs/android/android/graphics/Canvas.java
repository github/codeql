// Generated automatically from android.graphics.Canvas for testing purposes

package android.graphics;

import android.graphics.Bitmap;
import android.graphics.BlendMode;
import android.graphics.DrawFilter;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Picture;
import android.graphics.PorterDuff;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Region;
import android.graphics.RenderNode;
import android.graphics.text.MeasuredText;

public class Canvas
{
    public Canvas(){}
    public Canvas(Bitmap p0){}
    public DrawFilter getDrawFilter(){ return null; }
    public boolean clipOutPath(Path p0){ return false; }
    public boolean clipOutRect(Rect p0){ return false; }
    public boolean clipOutRect(RectF p0){ return false; }
    public boolean clipOutRect(float p0, float p1, float p2, float p3){ return false; }
    public boolean clipOutRect(int p0, int p1, int p2, int p3){ return false; }
    public boolean clipPath(Path p0){ return false; }
    public boolean clipPath(Path p0, Region.Op p1){ return false; }
    public boolean clipRect(Rect p0){ return false; }
    public boolean clipRect(Rect p0, Region.Op p1){ return false; }
    public boolean clipRect(RectF p0){ return false; }
    public boolean clipRect(RectF p0, Region.Op p1){ return false; }
    public boolean clipRect(float p0, float p1, float p2, float p3){ return false; }
    public boolean clipRect(float p0, float p1, float p2, float p3, Region.Op p4){ return false; }
    public boolean clipRect(int p0, int p1, int p2, int p3){ return false; }
    public boolean getClipBounds(Rect p0){ return false; }
    public boolean isHardwareAccelerated(){ return false; }
    public boolean isOpaque(){ return false; }
    public boolean quickReject(Path p0){ return false; }
    public boolean quickReject(Path p0, Canvas.EdgeType p1){ return false; }
    public boolean quickReject(RectF p0){ return false; }
    public boolean quickReject(RectF p0, Canvas.EdgeType p1){ return false; }
    public boolean quickReject(float p0, float p1, float p2, float p3){ return false; }
    public boolean quickReject(float p0, float p1, float p2, float p3, Canvas.EdgeType p4){ return false; }
    public final Matrix getMatrix(){ return null; }
    public final Rect getClipBounds(){ return null; }
    public final void rotate(float p0, float p1, float p2){}
    public final void scale(float p0, float p1, float p2, float p3){}
    public int getDensity(){ return 0; }
    public int getHeight(){ return 0; }
    public int getMaximumBitmapHeight(){ return 0; }
    public int getMaximumBitmapWidth(){ return 0; }
    public int getSaveCount(){ return 0; }
    public int getWidth(){ return 0; }
    public int save(){ return 0; }
    public int saveLayer(RectF p0, Paint p1){ return 0; }
    public int saveLayer(RectF p0, Paint p1, int p2){ return 0; }
    public int saveLayer(float p0, float p1, float p2, float p3, Paint p4){ return 0; }
    public int saveLayer(float p0, float p1, float p2, float p3, Paint p4, int p5){ return 0; }
    public int saveLayerAlpha(RectF p0, int p1){ return 0; }
    public int saveLayerAlpha(RectF p0, int p1, int p2){ return 0; }
    public int saveLayerAlpha(float p0, float p1, float p2, float p3, int p4){ return 0; }
    public int saveLayerAlpha(float p0, float p1, float p2, float p3, int p4, int p5){ return 0; }
    public static int ALL_SAVE_FLAG = 0;
    public void concat(Matrix p0){}
    public void disableZ(){}
    public void drawARGB(int p0, int p1, int p2, int p3){}
    public void drawArc(RectF p0, float p1, float p2, boolean p3, Paint p4){}
    public void drawArc(float p0, float p1, float p2, float p3, float p4, float p5, boolean p6, Paint p7){}
    public void drawBitmap(Bitmap p0, Matrix p1, Paint p2){}
    public void drawBitmap(Bitmap p0, Rect p1, Rect p2, Paint p3){}
    public void drawBitmap(Bitmap p0, Rect p1, RectF p2, Paint p3){}
    public void drawBitmap(Bitmap p0, float p1, float p2, Paint p3){}
    public void drawBitmap(int[] p0, int p1, int p2, float p3, float p4, int p5, int p6, boolean p7, Paint p8){}
    public void drawBitmap(int[] p0, int p1, int p2, int p3, int p4, int p5, int p6, boolean p7, Paint p8){}
    public void drawBitmapMesh(Bitmap p0, int p1, int p2, float[] p3, int p4, int[] p5, int p6, Paint p7){}
    public void drawCircle(float p0, float p1, float p2, Paint p3){}
    public void drawColor(int p0){}
    public void drawColor(int p0, BlendMode p1){}
    public void drawColor(int p0, PorterDuff.Mode p1){}
    public void drawColor(long p0){}
    public void drawColor(long p0, BlendMode p1){}
    public void drawDoubleRoundRect(RectF p0, float p1, float p2, RectF p3, float p4, float p5, Paint p6){}
    public void drawDoubleRoundRect(RectF p0, float[] p1, RectF p2, float[] p3, Paint p4){}
    public void drawLine(float p0, float p1, float p2, float p3, Paint p4){}
    public void drawLines(float[] p0, Paint p1){}
    public void drawLines(float[] p0, int p1, int p2, Paint p3){}
    public void drawOval(RectF p0, Paint p1){}
    public void drawOval(float p0, float p1, float p2, float p3, Paint p4){}
    public void drawPaint(Paint p0){}
    public void drawPath(Path p0, Paint p1){}
    public void drawPicture(Picture p0){}
    public void drawPicture(Picture p0, Rect p1){}
    public void drawPicture(Picture p0, RectF p1){}
    public void drawPoint(float p0, float p1, Paint p2){}
    public void drawPoints(float[] p0, Paint p1){}
    public void drawPoints(float[] p0, int p1, int p2, Paint p3){}
    public void drawPosText(String p0, float[] p1, Paint p2){}
    public void drawPosText(char[] p0, int p1, int p2, float[] p3, Paint p4){}
    public void drawRGB(int p0, int p1, int p2){}
    public void drawRect(Rect p0, Paint p1){}
    public void drawRect(RectF p0, Paint p1){}
    public void drawRect(float p0, float p1, float p2, float p3, Paint p4){}
    public void drawRenderNode(RenderNode p0){}
    public void drawRoundRect(RectF p0, float p1, float p2, Paint p3){}
    public void drawRoundRect(float p0, float p1, float p2, float p3, float p4, float p5, Paint p6){}
    public void drawText(CharSequence p0, int p1, int p2, float p3, float p4, Paint p5){}
    public void drawText(String p0, float p1, float p2, Paint p3){}
    public void drawText(String p0, int p1, int p2, float p3, float p4, Paint p5){}
    public void drawText(char[] p0, int p1, int p2, float p3, float p4, Paint p5){}
    public void drawTextOnPath(String p0, Path p1, float p2, float p3, Paint p4){}
    public void drawTextOnPath(char[] p0, int p1, int p2, Path p3, float p4, float p5, Paint p6){}
    public void drawTextRun(CharSequence p0, int p1, int p2, int p3, int p4, float p5, float p6, boolean p7, Paint p8){}
    public void drawTextRun(MeasuredText p0, int p1, int p2, int p3, int p4, float p5, float p6, boolean p7, Paint p8){}
    public void drawTextRun(char[] p0, int p1, int p2, int p3, int p4, float p5, float p6, boolean p7, Paint p8){}
    public void drawVertices(Canvas.VertexMode p0, int p1, float[] p2, int p3, float[] p4, int p5, int[] p6, int p7, short[] p8, int p9, int p10, Paint p11){}
    public void enableZ(){}
    public void getMatrix(Matrix p0){}
    public void restore(){}
    public void restoreToCount(int p0){}
    public void rotate(float p0){}
    public void scale(float p0, float p1){}
    public void setBitmap(Bitmap p0){}
    public void setDensity(int p0){}
    public void setDrawFilter(DrawFilter p0){}
    public void setMatrix(Matrix p0){}
    public void skew(float p0, float p1){}
    public void translate(float p0, float p1){}
    static public enum EdgeType
    {
        AA, BW;
        private EdgeType() {}
    }
    static public enum VertexMode
    {
        TRIANGLES, TRIANGLE_FAN, TRIANGLE_STRIP;
        private VertexMode() {}
    }
}
