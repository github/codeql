// Generated automatically from org.apache.hadoop.io.BinaryComparable for testing purposes

package org.apache.hadoop.io;


abstract public class BinaryComparable implements Comparable<BinaryComparable>
{
    public BinaryComparable(){}
    public abstract byte[] getBytes();
    public abstract int getLength();
    public boolean equals(Object p0){ return false; }
    public int compareTo(BinaryComparable p0){ return 0; }
    public int compareTo(byte[] p0, int p1, int p2){ return 0; }
    public int hashCode(){ return 0; }
}
