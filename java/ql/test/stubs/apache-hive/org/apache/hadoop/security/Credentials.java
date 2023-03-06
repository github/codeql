// Generated automatically from org.apache.hadoop.security.Credentials for testing purposes

package org.apache.hadoop.security;

import java.io.DataInput;
import java.io.DataInputStream;
import java.io.DataOutput;
import java.io.DataOutputStream;
import java.io.File;
import java.util.Collection;
import java.util.List;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.security.token.Token;
import org.apache.hadoop.security.token.TokenIdentifier;

public class Credentials implements Writable
{
    public Collection<Token<? extends TokenIdentifier>> getAllTokens(){ return null; }
    public Credentials(){}
    public Credentials(Credentials p0){}
    public List<Text> getAllSecretKeys(){ return null; }
    public Token<? extends TokenIdentifier> getToken(Text p0){ return null; }
    public byte[] getSecretKey(Text p0){ return null; }
    public int numberOfSecretKeys(){ return 0; }
    public int numberOfTokens(){ return 0; }
    public static Credentials readTokenStorageFile(File p0, Configuration p1){ return null; }
    public static Credentials readTokenStorageFile(Path p0, Configuration p1){ return null; }
    public void addAll(Credentials p0){}
    public void addSecretKey(Text p0, byte[] p1){}
    public void addToken(Text p0, Token<? extends TokenIdentifier> p1){}
    public void mergeAll(Credentials p0){}
    public void readFields(DataInput p0){}
    public void readTokenStorageStream(DataInputStream p0){}
    public void removeSecretKey(Text p0){}
    public void write(DataOutput p0){}
    public void writeTokenStorageFile(Path p0, Configuration p1){}
    public void writeTokenStorageFile(Path p0, Configuration p1, Credentials.SerializedFormat p2){}
    public void writeTokenStorageToStream(DataOutputStream p0){}
    public void writeTokenStorageToStream(DataOutputStream p0, Credentials.SerializedFormat p1){}
    static public enum SerializedFormat
    {
        PROTOBUF, WRITABLE;
        private SerializedFormat() {}
    }
}
