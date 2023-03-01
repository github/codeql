// Generated automatically from org.apache.hadoop.hive.metastore.security.DelegationTokenSecretManager for testing purposes

package org.apache.hadoop.hive.metastore.security;

import org.apache.hadoop.hive.metastore.security.DelegationTokenIdentifier;
import org.apache.hadoop.security.token.Token;
import org.apache.hadoop.security.token.TokenIdentifier;
import org.apache.hadoop.security.token.delegation.AbstractDelegationTokenIdentifier;
import org.apache.hadoop.security.token.delegation.AbstractDelegationTokenSecretManager;

public class DelegationTokenSecretManager extends AbstractDelegationTokenSecretManager<DelegationTokenIdentifier>
{
    protected DelegationTokenSecretManager() {}
    protected DelegationTokenIdentifier getTokenIdentifier(Token<DelegationTokenIdentifier> p0){ return null; }
    public DelegationTokenIdentifier createIdentifier(){ return null; }
    public DelegationTokenSecretManager(long p0, long p1, long p2, long p3){}
    public String getDelegationToken(String p0, String p1){ return null; }
    public String getUserFromToken(String p0){ return null; }
    public String verifyDelegationToken(String p0){ return null; }
    public long renewDelegationToken(String p0){ return 0; }
    public void cancelDelegationToken(String p0){}
}
