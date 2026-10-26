// Generated automatically from javafx.scene.input.PickResult for testing purposes

package javafx.scene.input;

import javafx.event.EventTarget;
import javafx.geometry.Point2D;
import javafx.geometry.Point3D;
import javafx.scene.Node;

public class PickResult
{
    protected PickResult() {}
    public PickResult(EventTarget p0, double p1, double p2){}
    public PickResult(Node p0, Point3D p1, double p2){}
    public PickResult(Node p0, Point3D p1, double p2, int p3, Point2D p4){}
    public PickResult(Node p0, Point3D p1, double p2, int p3, Point3D p4, Point2D p5){}
    public String toString(){ return null; }
    public final Node getIntersectedNode(){ return null; }
    public final Point2D getIntersectedTexCoord(){ return null; }
    public final Point3D getIntersectedNormal(){ return null; }
    public final Point3D getIntersectedPoint(){ return null; }
    public final double getIntersectedDistance(){ return 0; }
    public final int getIntersectedFace(){ return 0; }
    public static int FACE_UNDEFINED = 0;
}
