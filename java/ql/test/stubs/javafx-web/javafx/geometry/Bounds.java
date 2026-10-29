// Generated automatically from javafx.geometry.Bounds for testing purposes

package javafx.geometry;

import javafx.geometry.Point2D;
import javafx.geometry.Point3D;

abstract public class Bounds
{
    protected Bounds() {}
    protected Bounds(double p0, double p1, double p2, double p3, double p4, double p5){}
    public abstract boolean contains(Bounds p0);
    public abstract boolean contains(Point2D p0);
    public abstract boolean contains(Point3D p0);
    public abstract boolean contains(double p0, double p1);
    public abstract boolean contains(double p0, double p1, double p2);
    public abstract boolean contains(double p0, double p1, double p2, double p3);
    public abstract boolean contains(double p0, double p1, double p2, double p3, double p4, double p5);
    public abstract boolean intersects(Bounds p0);
    public abstract boolean intersects(double p0, double p1, double p2, double p3);
    public abstract boolean intersects(double p0, double p1, double p2, double p3, double p4, double p5);
    public abstract boolean isEmpty();
    public final double getCenterX(){ return 0; }
    public final double getCenterY(){ return 0; }
    public final double getCenterZ(){ return 0; }
    public final double getDepth(){ return 0; }
    public final double getHeight(){ return 0; }
    public final double getMaxX(){ return 0; }
    public final double getMaxY(){ return 0; }
    public final double getMaxZ(){ return 0; }
    public final double getMinX(){ return 0; }
    public final double getMinY(){ return 0; }
    public final double getMinZ(){ return 0; }
    public final double getWidth(){ return 0; }
}
