// Generated automatically from org.apache.hadoop.security.token.delegation.DelegationKey for testing purposes

package org.apache.hadoop.security.token.delegation;

import java.io.DataInput;
import java.io.DataOutput;
import javax.crypto.SecretKey;
import org.apache.hadoop.io.Writable;

public class DelegationKey implements Writable
{
    public DelegationKey(){}
    public DelegationKey(int p0, long p1, SecretKey p2){}
    public DelegationKey(int p0, long p1, byte[] p2){}
    public SecretKey getKey(){ return null; }
    public boolean equals(Object p0){ return false; }
    public byte[] getEncodedKey(){ return null; }
    public int getKeyId(){ return 0; }
    public int hashCode(){ return 0; }
    public long getExpiryDate(){ return 0; }
    public void readFields(DataInput p0){}
    public void setExpiryDate(long p0){}
    public void write(DataOutput p0){}
}
