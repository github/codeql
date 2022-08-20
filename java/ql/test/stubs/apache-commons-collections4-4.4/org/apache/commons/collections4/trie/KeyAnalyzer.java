// Generated automatically from org.apache.commons.collections4.trie.KeyAnalyzer for testing purposes

package org.apache.commons.collections4.trie;

import java.io.Serializable;
import java.util.Comparator;

abstract public class KeyAnalyzer<K> implements Comparator<K>, Serializable
{
    public KeyAnalyzer(){}
    public abstract boolean isBitSet(K p0, int p1, int p2);
    public abstract boolean isPrefix(K p0, int p1, int p2, K p3);
    public abstract int bitIndex(K p0, int p1, int p2, K p3, int p4, int p5);
    public abstract int bitsPerElement();
    public abstract int lengthInBits(K p0);
    public int compare(K p0, K p1){ return 0; }
    public static int EQUAL_BIT_KEY = 0;
    public static int NULL_BIT_KEY = 0;
    public static int OUT_OF_BOUNDS_BIT_KEY = 0;
    static boolean isEqualBitKey(int p0){ return false; }
    static boolean isNullBitKey(int p0){ return false; }
    static boolean isOutOfBoundsIndex(int p0){ return false; }
    static boolean isValidBitIndex(int p0){ return false; }
}
