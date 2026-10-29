// Generated automatically from okio.Segment for testing purposes

package okio;


public class Segment
{
    public Segment next = null;
    public Segment prev = null;
    public Segment(){}
    public Segment(byte[] p0, int p1, int p2, boolean p3, boolean p4){}
    public boolean owner = false;
    public boolean shared = false;
    public final Segment pop(){ return null; }
    public final Segment push(Segment p0){ return null; }
    public final Segment sharedCopy(){ return null; }
    public final Segment split(int p0){ return null; }
    public final Segment unsharedCopy(){ return null; }
    public final byte[] data = null;
    public final void compact(){}
    public final void writeTo(Segment p0, int p1){}
    public int limit = 0;
    public int pos = 0;
    public static Segment.Companion Companion = null;
    public static int SHARE_MINIMUM = 0;
    public static int SIZE = 0;
    static public class Companion
    {
        protected Companion() {}
    }
}
