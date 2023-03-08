// Generated automatically from org.apache.hadoop.security.token.TokenIdentifier for testing purposes

package org.apache.hadoop.security.token;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.security.UserGroupInformation;

abstract public class TokenIdentifier implements Writable
{
    public String getTrackingId(){ return null; }
    public TokenIdentifier(){}
    public abstract Text getKind();
    public abstract UserGroupInformation getUser();
    public byte[] getBytes(){ return null; }
}
