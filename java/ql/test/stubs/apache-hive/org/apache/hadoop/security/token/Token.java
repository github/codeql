// Generated automatically from org.apache.hadoop.security.token.Token for testing purposes

package org.apache.hadoop.security.token;

import java.io.DataInput;
import java.io.DataOutput;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.security.proto.SecurityProtos;
import org.apache.hadoop.security.token.SecretManager;
import org.apache.hadoop.security.token.TokenIdentifier;
import org.slf4j.Logger;

public class Token<T extends TokenIdentifier> implements Writable
{
    public SecurityProtos.TokenProto toTokenProto(){ return null; }
    public String buildCacheKey(){ return null; }
    public String encodeToUrlString(){ return null; }
    public String toString(){ return null; }
    public T decodeIdentifier(){ return null; }
    public Text getKind(){ return null; }
    public Text getService(){ return null; }
    public Token(){}
    public Token(SecurityProtos.TokenProto p0){}
    public Token(T p0, org.apache.hadoop.security.token.SecretManager<T> p1){}
    public Token(Token<T> p0){}
    public Token(byte[] p0, byte[] p1, Text p2, Text p3){}
    public Token<T> copyToken(){ return null; }
    public Token<T> privateClone(Text p0){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean isManaged(){ return false; }
    public boolean isPrivate(){ return false; }
    public boolean isPrivateCloneOf(Text p0){ return false; }
    public byte[] getIdentifier(){ return null; }
    public byte[] getPassword(){ return null; }
    public int hashCode(){ return 0; }
    public long renew(Configuration p0){ return 0; }
    public static Logger LOG = null;
    public void cancel(Configuration p0){}
    public void decodeFromUrlString(String p0){}
    public void readFields(DataInput p0){}
    public void setKind(Text p0){}
    public void setService(Text p0){}
    public void write(DataOutput p0){}
}
