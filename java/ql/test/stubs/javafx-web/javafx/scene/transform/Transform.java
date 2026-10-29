// Generated automatically from javafx.scene.transform.Transform for testing purposes

package javafx.scene.transform;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.ReadOnlyBooleanProperty;
import javafx.event.Event;
import javafx.event.EventDispatchChain;
import javafx.event.EventHandler;
import javafx.event.EventTarget;
import javafx.event.EventType;
import javafx.geometry.Bounds;
import javafx.geometry.Point2D;
import javafx.geometry.Point3D;
import javafx.scene.transform.Affine;
import javafx.scene.transform.MatrixType;
import javafx.scene.transform.Rotate;
import javafx.scene.transform.Scale;
import javafx.scene.transform.Shear;
import javafx.scene.transform.TransformChangedEvent;
import javafx.scene.transform.Translate;

abstract public class Transform implements Cloneable, EventTarget
{
    protected void transformChanged(){}
    public Bounds inverseTransform(Bounds p0){ return null; }
    public Bounds transform(Bounds p0){ return null; }
    public EventDispatchChain buildEventDispatchChain(EventDispatchChain p0){ return null; }
    public Point2D deltaTransform(Point2D p0){ return null; }
    public Point2D deltaTransform(double p0, double p1){ return null; }
    public Point2D inverseDeltaTransform(Point2D p0){ return null; }
    public Point2D inverseDeltaTransform(double p0, double p1){ return null; }
    public Point2D inverseTransform(Point2D p0){ return null; }
    public Point2D inverseTransform(double p0, double p1){ return null; }
    public Point2D transform(Point2D p0){ return null; }
    public Point2D transform(double p0, double p1){ return null; }
    public Point3D deltaTransform(Point3D p0){ return null; }
    public Point3D deltaTransform(double p0, double p1, double p2){ return null; }
    public Point3D inverseDeltaTransform(Point3D p0){ return null; }
    public Point3D inverseDeltaTransform(double p0, double p1, double p2){ return null; }
    public Point3D inverseTransform(Point3D p0){ return null; }
    public Point3D inverseTransform(double p0, double p1, double p2){ return null; }
    public Point3D transform(Point3D p0){ return null; }
    public Point3D transform(double p0, double p1, double p2){ return null; }
    public Transform clone(){ return null; }
    public Transform createConcatenation(Transform p0){ return null; }
    public Transform createInverse(){ return null; }
    public Transform(){}
    public boolean similarTo(Transform p0, Bounds p1, double p2){ return false; }
    public double determinant(){ return 0; }
    public double getElement(MatrixType p0, int p1, int p2){ return 0; }
    public double getMxx(){ return 0; }
    public double getMxy(){ return 0; }
    public double getMxz(){ return 0; }
    public double getMyx(){ return 0; }
    public double getMyy(){ return 0; }
    public double getMyz(){ return 0; }
    public double getMzx(){ return 0; }
    public double getMzy(){ return 0; }
    public double getMzz(){ return 0; }
    public double getTx(){ return 0; }
    public double getTy(){ return 0; }
    public double getTz(){ return 0; }
    public double[] column(MatrixType p0, int p1){ return null; }
    public double[] column(MatrixType p0, int p1, double[] p2){ return null; }
    public double[] row(MatrixType p0, int p1){ return null; }
    public double[] row(MatrixType p0, int p1, double[] p2){ return null; }
    public double[] toArray(MatrixType p0){ return null; }
    public double[] toArray(MatrixType p0, double[] p1){ return null; }
    public final <T extends Event> void addEventFilter(javafx.event.EventType<T> p0, javafx.event.EventHandler<? super T> p1){}
    public final <T extends Event> void addEventHandler(javafx.event.EventType<T> p0, javafx.event.EventHandler<? super T> p1){}
    public final <T extends Event> void removeEventFilter(javafx.event.EventType<T> p0, javafx.event.EventHandler<? super T> p1){}
    public final <T extends Event> void removeEventHandler(javafx.event.EventType<T> p0, javafx.event.EventHandler<? super T> p1){}
    public final EventHandler<? super TransformChangedEvent> getOnTransformChanged(){ return null; }
    public final ObjectProperty<EventHandler<? super TransformChangedEvent>> onTransformChangedProperty(){ return null; }
    public final ReadOnlyBooleanProperty identityProperty(){ return null; }
    public final ReadOnlyBooleanProperty type2DProperty(){ return null; }
    public final boolean isIdentity(){ return false; }
    public final boolean isType2D(){ return false; }
    public final void setOnTransformChanged(EventHandler<? super TransformChangedEvent> p0){}
    public static Affine affine(double p0, double p1, double p2, double p3, double p4, double p5){ return null; }
    public static Affine affine(double p0, double p1, double p2, double p3, double p4, double p5, double p6, double p7, double p8, double p9, double p10, double p11){ return null; }
    public static Rotate rotate(double p0, double p1, double p2){ return null; }
    public static Scale scale(double p0, double p1){ return null; }
    public static Scale scale(double p0, double p1, double p2, double p3){ return null; }
    public static Shear shear(double p0, double p1){ return null; }
    public static Shear shear(double p0, double p1, double p2, double p3){ return null; }
    public static Translate translate(double p0, double p1){ return null; }
    public void inverseTransform2DPoints(double[] p0, int p1, double[] p2, int p3, int p4){}
    public void inverseTransform3DPoints(double[] p0, int p1, double[] p2, int p3, int p4){}
    public void transform2DPoints(double[] p0, int p1, double[] p2, int p3, int p4){}
    public void transform3DPoints(double[] p0, int p1, double[] p2, int p3, int p4){}
}
