// Generated automatically from android.graphics.Matrix for testing purposes

package android.graphics;

import android.graphics.RectF;
import java.io.PrintWriter;

public class Matrix
{
    public Matrix(){}
    public Matrix(Matrix p0){}
    public String toShortString(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean invert(Matrix p0){ return false; }
    public boolean isAffine(){ return false; }
    public boolean isIdentity(){ return false; }
    public boolean mapRect(RectF p0){ return false; }
    public boolean mapRect(RectF p0, RectF p1){ return false; }
    public boolean postConcat(Matrix p0){ return false; }
    public boolean postRotate(float p0){ return false; }
    public boolean postRotate(float p0, float p1, float p2){ return false; }
    public boolean postScale(float p0, float p1){ return false; }
    public boolean postScale(float p0, float p1, float p2, float p3){ return false; }
    public boolean postSkew(float p0, float p1){ return false; }
    public boolean postSkew(float p0, float p1, float p2, float p3){ return false; }
    public boolean postTranslate(float p0, float p1){ return false; }
    public boolean preConcat(Matrix p0){ return false; }
    public boolean preRotate(float p0){ return false; }
    public boolean preRotate(float p0, float p1, float p2){ return false; }
    public boolean preScale(float p0, float p1){ return false; }
    public boolean preScale(float p0, float p1, float p2, float p3){ return false; }
    public boolean preSkew(float p0, float p1){ return false; }
    public boolean preSkew(float p0, float p1, float p2, float p3){ return false; }
    public boolean preTranslate(float p0, float p1){ return false; }
    public boolean rectStaysRect(){ return false; }
    public boolean setConcat(Matrix p0, Matrix p1){ return false; }
    public boolean setPolyToPoly(float[] p0, int p1, float[] p2, int p3, int p4){ return false; }
    public boolean setRectToRect(RectF p0, RectF p1, Matrix.ScaleToFit p2){ return false; }
    public final void dump(PrintWriter p0){}
    public float mapRadius(float p0){ return 0; }
    public int hashCode(){ return 0; }
    public static Matrix IDENTITY_MATRIX = null;
    public static int MPERSP_0 = 0;
    public static int MPERSP_1 = 0;
    public static int MPERSP_2 = 0;
    public static int MSCALE_X = 0;
    public static int MSCALE_Y = 0;
    public static int MSKEW_X = 0;
    public static int MSKEW_Y = 0;
    public static int MTRANS_X = 0;
    public static int MTRANS_Y = 0;
    public void getValues(float[] p0){}
    public void mapPoints(float[] p0){}
    public void mapPoints(float[] p0, float[] p1){}
    public void mapPoints(float[] p0, int p1, float[] p2, int p3, int p4){}
    public void mapVectors(float[] p0){}
    public void mapVectors(float[] p0, float[] p1){}
    public void mapVectors(float[] p0, int p1, float[] p2, int p3, int p4){}
    public void reset(){}
    public void set(Matrix p0){}
    public void setRotate(float p0){}
    public void setRotate(float p0, float p1, float p2){}
    public void setScale(float p0, float p1){}
    public void setScale(float p0, float p1, float p2, float p3){}
    public void setSinCos(float p0, float p1){}
    public void setSinCos(float p0, float p1, float p2, float p3){}
    public void setSkew(float p0, float p1){}
    public void setSkew(float p0, float p1, float p2, float p3){}
    public void setTranslate(float p0, float p1){}
    public void setValues(float[] p0){}
    static public enum ScaleToFit
    {
        CENTER, END, FILL, START;
        private ScaleToFit() {}
    }
}
