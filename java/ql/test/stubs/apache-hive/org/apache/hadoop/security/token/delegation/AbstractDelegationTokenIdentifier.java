// Generated automatically from org.apache.hadoop.security.token.delegation.AbstractDelegationTokenIdentifier for testing purposes

package org.apache.hadoop.security.token.delegation;

import java.io.DataInput;
import java.io.DataOutput;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.security.UserGroupInformation;
import org.apache.hadoop.security.token.TokenIdentifier;

abstract public class AbstractDelegationTokenIdentifier extends TokenIdentifier
{
    protected static boolean isEqual(Object p0, Object p1){ return false; }
    public AbstractDelegationTokenIdentifier(){}
    public AbstractDelegationTokenIdentifier(Text p0, Text p1, Text p2){}
    public String toString(){ return null; }
    public String toStringStable(){ return null; }
    public Text getOwner(){ return null; }
    public Text getRealUser(){ return null; }
    public Text getRenewer(){ return null; }
    public UserGroupInformation getUser(){ return null; }
    public abstract Text getKind();
    public boolean equals(Object p0){ return false; }
    public int getMasterKeyId(){ return 0; }
    public int getSequenceNumber(){ return 0; }
    public int hashCode(){ return 0; }
    public long getIssueDate(){ return 0; }
    public long getMaxDate(){ return 0; }
    public void readFields(DataInput p0){}
    public void setIssueDate(long p0){}
    public void setMasterKeyId(int p0){}
    public void setMaxDate(long p0){}
    public void setOwner(Text p0){}
    public void setRealUser(Text p0){}
    public void setRenewer(Text p0){}
    public void setSequenceNumber(int p0){}
    public void write(DataOutput p0){}
}
