// Generated automatically from android.graphics.Region for testing purposes

package android.graphics;

import android.graphics.Path;
import android.graphics.Rect;
import android.os.Parcel;
import android.os.Parcelable;

public class Region implements Parcelable
{
    protected void finalize(){}
    public Path getBoundaryPath(){ return null; }
    public Rect getBounds(){ return null; }
    public Region(){}
    public Region(Rect p0){}
    public Region(Region p0){}
    public Region(int p0, int p1, int p2, int p3){}
    public String toString(){ return null; }
    public boolean contains(int p0, int p1){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean getBoundaryPath(Path p0){ return false; }
    public boolean getBounds(Rect p0){ return false; }
    public boolean isComplex(){ return false; }
    public boolean isEmpty(){ return false; }
    public boolean isRect(){ return false; }
    public boolean op(Rect p0, Region p1, Region.Op p2){ return false; }
    public boolean op(Rect p0, Region.Op p1){ return false; }
    public boolean op(Region p0, Region p1, Region.Op p2){ return false; }
    public boolean op(Region p0, Region.Op p1){ return false; }
    public boolean op(int p0, int p1, int p2, int p3, Region.Op p4){ return false; }
    public boolean quickContains(Rect p0){ return false; }
    public boolean quickContains(int p0, int p1, int p2, int p3){ return false; }
    public boolean quickReject(Rect p0){ return false; }
    public boolean quickReject(Region p0){ return false; }
    public boolean quickReject(int p0, int p1, int p2, int p3){ return false; }
    public boolean set(Rect p0){ return false; }
    public boolean set(Region p0){ return false; }
    public boolean set(int p0, int p1, int p2, int p3){ return false; }
    public boolean setPath(Path p0, Region p1){ return false; }
    public final boolean union(Rect p0){ return false; }
    public int describeContents(){ return 0; }
    public static Parcelable.Creator<Region> CREATOR = null;
    public void setEmpty(){}
    public void translate(int p0, int p1){}
    public void translate(int p0, int p1, Region p2){}
    public void writeToParcel(Parcel p0, int p1){}
    static public enum Op
    {
        DIFFERENCE, INTERSECT, REPLACE, REVERSE_DIFFERENCE, UNION, XOR;
        private Op() {}
    }
}
