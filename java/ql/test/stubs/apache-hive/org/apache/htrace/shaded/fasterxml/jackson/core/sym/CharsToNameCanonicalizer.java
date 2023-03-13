// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.core.sym.CharsToNameCanonicalizer for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.core.sym;

import java.util.BitSet;

public class CharsToNameCanonicalizer
{
    class Bucket {}
    protected CharsToNameCanonicalizer() {}
    protected BitSet _overflows = null;
    protected CharsToNameCanonicalizer _parent = null;
    protected CharsToNameCanonicalizer.Bucket[] _buckets = null;
    protected String[] _symbols = null;
    protected boolean _canonicalize = false;
    protected boolean _dirty = false;
    protected final int _flags = 0;
    protected int _indexMask = 0;
    protected int _longestCollisionList = 0;
    protected int _size = 0;
    protected int _sizeThreshold = 0;
    protected static CharsToNameCanonicalizer createRoot(int p0){ return null; }
    protected static int DEFAULT_T_SIZE = 0;
    protected static int MAX_T_SIZE = 0;
    protected void reportTooManyCollisions(int p0){}
    public CharsToNameCanonicalizer makeChild(int p0){ return null; }
    public String findSymbol(char[] p0, int p1, int p2, int p3){ return null; }
    public boolean maybeDirty(){ return false; }
    public int _hashToIndex(int p0){ return 0; }
    public int bucketCount(){ return 0; }
    public int calcHash(String p0){ return 0; }
    public int calcHash(char[] p0, int p1, int p2){ return 0; }
    public int collisionCount(){ return 0; }
    public int hashSeed(){ return 0; }
    public int maxCollisionLength(){ return 0; }
    public int size(){ return 0; }
    public static CharsToNameCanonicalizer createRoot(){ return null; }
    public static int HASH_MULT = 0;
    public void release(){}
}
