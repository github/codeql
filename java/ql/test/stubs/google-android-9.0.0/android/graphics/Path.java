// Generated automatically from android.graphics.Path for testing purposes

package android.graphics;

import android.graphics.Matrix;
import android.graphics.RectF;

public class Path
{
    public Path(){}
    public Path(Path p0){}
    public Path.FillType getFillType(){ return null; }
    public boolean isConvex(){ return false; }
    public boolean isEmpty(){ return false; }
    public boolean isInverseFillType(){ return false; }
    public boolean isRect(RectF p0){ return false; }
    public boolean op(Path p0, Path p1, Path.Op p2){ return false; }
    public boolean op(Path p0, Path.Op p1){ return false; }
    public float[] approximate(float p0){ return null; }
    public void addArc(RectF p0, float p1, float p2){}
    public void addArc(float p0, float p1, float p2, float p3, float p4, float p5){}
    public void addCircle(float p0, float p1, float p2, Path.Direction p3){}
    public void addOval(RectF p0, Path.Direction p1){}
    public void addOval(float p0, float p1, float p2, float p3, Path.Direction p4){}
    public void addPath(Path p0){}
    public void addPath(Path p0, Matrix p1){}
    public void addPath(Path p0, float p1, float p2){}
    public void addRect(RectF p0, Path.Direction p1){}
    public void addRect(float p0, float p1, float p2, float p3, Path.Direction p4){}
    public void addRoundRect(RectF p0, float p1, float p2, Path.Direction p3){}
    public void addRoundRect(RectF p0, float[] p1, Path.Direction p2){}
    public void addRoundRect(float p0, float p1, float p2, float p3, float p4, float p5, Path.Direction p6){}
    public void addRoundRect(float p0, float p1, float p2, float p3, float[] p4, Path.Direction p5){}
    public void arcTo(RectF p0, float p1, float p2){}
    public void arcTo(RectF p0, float p1, float p2, boolean p3){}
    public void arcTo(float p0, float p1, float p2, float p3, float p4, float p5, boolean p6){}
    public void close(){}
    public void computeBounds(RectF p0, boolean p1){}
    public void cubicTo(float p0, float p1, float p2, float p3, float p4, float p5){}
    public void incReserve(int p0){}
    public void lineTo(float p0, float p1){}
    public void moveTo(float p0, float p1){}
    public void offset(float p0, float p1){}
    public void offset(float p0, float p1, Path p2){}
    public void quadTo(float p0, float p1, float p2, float p3){}
    public void rCubicTo(float p0, float p1, float p2, float p3, float p4, float p5){}
    public void rLineTo(float p0, float p1){}
    public void rMoveTo(float p0, float p1){}
    public void rQuadTo(float p0, float p1, float p2, float p3){}
    public void reset(){}
    public void rewind(){}
    public void set(Path p0){}
    public void setFillType(Path.FillType p0){}
    public void setLastPoint(float p0, float p1){}
    public void toggleInverseFillType(){}
    public void transform(Matrix p0){}
    public void transform(Matrix p0, Path p1){}
    static public enum Direction
    {
        CCW, CW;
        private Direction() {}
    }
    static public enum FillType
    {
        EVEN_ODD, INVERSE_EVEN_ODD, INVERSE_WINDING, WINDING;
        private FillType() {}
    }
    static public enum Op
    {
        DIFFERENCE, INTERSECT, REVERSE_DIFFERENCE, UNION, XOR;
        private Op() {}
    }
}
