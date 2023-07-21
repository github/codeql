// Generated automatically from javafx.scene.transform.Affine for testing purposes

package javafx.scene.transform;

import javafx.beans.property.DoubleProperty;
import javafx.geometry.Point2D;
import javafx.geometry.Point3D;
import javafx.scene.transform.MatrixType;
import javafx.scene.transform.Transform;

public class Affine extends Transform
{
    public Affine clone(){ return null; }
    public Affine createInverse(){ return null; }
    public Affine(){}
    public Affine(Transform p0){}
    public Affine(double p0, double p1, double p2, double p3, double p4, double p5){}
    public Affine(double p0, double p1, double p2, double p3, double p4, double p5, double p6, double p7, double p8, double p9, double p10, double p11){}
    public Affine(double[] p0, MatrixType p1, int p2){}
    public Point2D deltaTransform(double p0, double p1){ return null; }
    public Point2D inverseDeltaTransform(double p0, double p1){ return null; }
    public Point2D inverseTransform(double p0, double p1){ return null; }
    public Point2D transform(double p0, double p1){ return null; }
    public Point3D deltaTransform(double p0, double p1, double p2){ return null; }
    public Point3D inverseDeltaTransform(double p0, double p1, double p2){ return null; }
    public Point3D inverseTransform(double p0, double p1, double p2){ return null; }
    public Point3D transform(double p0, double p1, double p2){ return null; }
    public String toString(){ return null; }
    public Transform createConcatenation(Transform p0){ return null; }
    public double determinant(){ return 0; }
    public final DoubleProperty mxxProperty(){ return null; }
    public final DoubleProperty mxyProperty(){ return null; }
    public final DoubleProperty mxzProperty(){ return null; }
    public final DoubleProperty myxProperty(){ return null; }
    public final DoubleProperty myyProperty(){ return null; }
    public final DoubleProperty myzProperty(){ return null; }
    public final DoubleProperty mzxProperty(){ return null; }
    public final DoubleProperty mzyProperty(){ return null; }
    public final DoubleProperty mzzProperty(){ return null; }
    public final DoubleProperty txProperty(){ return null; }
    public final DoubleProperty tyProperty(){ return null; }
    public final DoubleProperty tzProperty(){ return null; }
    public final double getMxx(){ return 0; }
    public final double getMxy(){ return 0; }
    public final double getMxz(){ return 0; }
    public final double getMyx(){ return 0; }
    public final double getMyy(){ return 0; }
    public final double getMyz(){ return 0; }
    public final double getMzx(){ return 0; }
    public final double getMzy(){ return 0; }
    public final double getMzz(){ return 0; }
    public final double getTx(){ return 0; }
    public final double getTy(){ return 0; }
    public final double getTz(){ return 0; }
    public final void setMxx(double p0){}
    public final void setMxy(double p0){}
    public final void setMxz(double p0){}
    public final void setMyx(double p0){}
    public final void setMyy(double p0){}
    public final void setMyz(double p0){}
    public final void setMzx(double p0){}
    public final void setMzy(double p0){}
    public final void setMzz(double p0){}
    public final void setTx(double p0){}
    public final void setTy(double p0){}
    public final void setTz(double p0){}
    public void append(Transform p0){}
    public void append(double p0, double p1, double p2, double p3, double p4, double p5){}
    public void append(double p0, double p1, double p2, double p3, double p4, double p5, double p6, double p7, double p8, double p9, double p10, double p11){}
    public void append(double[] p0, MatrixType p1, int p2){}
    public void appendRotation(double p0){}
    public void appendRotation(double p0, Point2D p1){}
    public void appendRotation(double p0, Point3D p1, Point3D p2){}
    public void appendRotation(double p0, double p1, double p2){}
    public void appendRotation(double p0, double p1, double p2, double p3, Point3D p4){}
    public void appendRotation(double p0, double p1, double p2, double p3, double p4, double p5, double p6){}
    public void appendScale(double p0, double p1){}
    public void appendScale(double p0, double p1, Point2D p2){}
    public void appendScale(double p0, double p1, double p2){}
    public void appendScale(double p0, double p1, double p2, Point3D p3){}
    public void appendScale(double p0, double p1, double p2, double p3){}
    public void appendScale(double p0, double p1, double p2, double p3, double p4, double p5){}
    public void appendShear(double p0, double p1){}
    public void appendShear(double p0, double p1, Point2D p2){}
    public void appendShear(double p0, double p1, double p2, double p3){}
    public void appendTranslation(double p0, double p1){}
    public void appendTranslation(double p0, double p1, double p2){}
    public void invert(){}
    public void prepend(Transform p0){}
    public void prepend(double p0, double p1, double p2, double p3, double p4, double p5){}
    public void prepend(double p0, double p1, double p2, double p3, double p4, double p5, double p6, double p7, double p8, double p9, double p10, double p11){}
    public void prepend(double[] p0, MatrixType p1, int p2){}
    public void prependRotation(double p0){}
    public void prependRotation(double p0, Point2D p1){}
    public void prependRotation(double p0, Point3D p1, Point3D p2){}
    public void prependRotation(double p0, double p1, double p2){}
    public void prependRotation(double p0, double p1, double p2, double p3, Point3D p4){}
    public void prependRotation(double p0, double p1, double p2, double p3, double p4, double p5, double p6){}
    public void prependScale(double p0, double p1){}
    public void prependScale(double p0, double p1, Point2D p2){}
    public void prependScale(double p0, double p1, double p2){}
    public void prependScale(double p0, double p1, double p2, Point3D p3){}
    public void prependScale(double p0, double p1, double p2, double p3){}
    public void prependScale(double p0, double p1, double p2, double p3, double p4, double p5){}
    public void prependShear(double p0, double p1){}
    public void prependShear(double p0, double p1, Point2D p2){}
    public void prependShear(double p0, double p1, double p2, double p3){}
    public void prependTranslation(double p0, double p1){}
    public void prependTranslation(double p0, double p1, double p2){}
    public void setElement(MatrixType p0, int p1, int p2, double p3){}
    public void setToIdentity(){}
    public void setToTransform(Transform p0){}
    public void setToTransform(double p0, double p1, double p2, double p3, double p4, double p5){}
    public void setToTransform(double p0, double p1, double p2, double p3, double p4, double p5, double p6, double p7, double p8, double p9, double p10, double p11){}
    public void setToTransform(double[] p0, MatrixType p1, int p2){}
}
