// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.core.sym.BytesToNameCanonicalizer for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.core.sym;

import java.util.BitSet;
import java.util.concurrent.atomic.AtomicReference;
import org.apache.htrace.shaded.fasterxml.jackson.core.sym.Name;

public class BytesToNameCanonicalizer
{
    class TableInfo {}
    class Bucket {}
    protected BytesToNameCanonicalizer() {}
    protected BitSet _overflows = null;
    protected BytesToNameCanonicalizer.Bucket[] _collList = null;
    protected Name[] _mainNames = null;
    protected boolean _intern = false;
    protected final AtomicReference<BytesToNameCanonicalizer.TableInfo> _tableInfo = null;
    protected final BytesToNameCanonicalizer _parent = null;
    protected final boolean _failOnDoS = false;
    protected int _collCount = 0;
    protected int _collEnd = 0;
    protected int _count = 0;
    protected int _hashMask = 0;
    protected int _longestCollisionList = 0;
    protected int[] _hash = null;
    protected static BytesToNameCanonicalizer createRoot(int p0){ return null; }
    protected static int[] calcQuads(byte[] p0){ return null; }
    protected void reportTooManyCollisions(int p0){}
    public BytesToNameCanonicalizer makeChild(boolean p0, boolean p1){ return null; }
    public BytesToNameCanonicalizer makeChild(int p0){ return null; }
    public Name addName(String p0, int p1, int p2){ return null; }
    public Name addName(String p0, int[] p1, int p2){ return null; }
    public Name findName(int p0){ return null; }
    public Name findName(int p0, int p1){ return null; }
    public Name findName(int[] p0, int p1){ return null; }
    public boolean maybeDirty(){ return false; }
    public int bucketCount(){ return 0; }
    public int calcHash(int p0){ return 0; }
    public int calcHash(int p0, int p1){ return 0; }
    public int calcHash(int[] p0, int p1){ return 0; }
    public int collisionCount(){ return 0; }
    public int hashSeed(){ return 0; }
    public int maxCollisionLength(){ return 0; }
    public int size(){ return 0; }
    public static BytesToNameCanonicalizer createRoot(){ return null; }
    public static Name getEmptyName(){ return null; }
    public void release(){}
}
