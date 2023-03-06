// Generated automatically from org.apache.hadoop.security.token.delegation.AbstractDelegationTokenSecretManager for testing purposes

package org.apache.hadoop.security.token.delegation;

import java.util.Collection;
import java.util.Map;
import javax.crypto.SecretKey;
import org.apache.hadoop.security.token.SecretManager;
import org.apache.hadoop.security.token.Token;
import org.apache.hadoop.security.token.TokenIdentifier;
import org.apache.hadoop.security.token.delegation.AbstractDelegationTokenIdentifier;
import org.apache.hadoop.security.token.delegation.DelegationKey;

abstract public class AbstractDelegationTokenSecretManager<TokenIdent extends AbstractDelegationTokenIdentifier> extends SecretManager<TokenIdent>
{
    protected AbstractDelegationTokenSecretManager() {}
    protected AbstractDelegationTokenSecretManager.DelegationTokenInformation checkToken(TokenIdent p0){ return null; }
    protected AbstractDelegationTokenSecretManager.DelegationTokenInformation getTokenInfo(TokenIdent p0){ return null; }
    protected DelegationKey getDelegationKey(int p0){ return null; }
    protected Object noInterruptsLock = null;
    protected String getTrackingIdIfEnabled(TokenIdent p0){ return null; }
    protected boolean running = false;
    protected boolean storeTokenTrackingId = false;
    protected byte[] createPassword(TokenIdent p0){ return null; }
    protected final Map<Integer, DelegationKey> allKeys = null;
    protected final Map<TokenIdent, AbstractDelegationTokenSecretManager.DelegationTokenInformation> currentTokens = null;
    protected int currentId = 0;
    protected int delegationTokenSequenceNumber = 0;
    protected int getCurrentKeyId(){ return 0; }
    protected int getDelegationTokenSeqNum(){ return 0; }
    protected int incrementCurrentKeyId(){ return 0; }
    protected int incrementDelegationTokenSeqNum(){ return 0; }
    protected void logExpireToken(TokenIdent p0){}
    protected void logExpireTokens(Collection<TokenIdent> p0){}
    protected void logUpdateMasterKey(DelegationKey p0){}
    protected void removeStoredMasterKey(DelegationKey p0){}
    protected void removeStoredToken(TokenIdent p0){}
    protected void setCurrentKeyId(int p0){}
    protected void setDelegationTokenSeqNum(int p0){}
    protected void storeDelegationKey(DelegationKey p0){}
    protected void storeNewMasterKey(DelegationKey p0){}
    protected void storeNewToken(TokenIdent p0, long p1){}
    protected void storeToken(TokenIdent p0, AbstractDelegationTokenSecretManager.DelegationTokenInformation p1){}
    protected void updateDelegationKey(DelegationKey p0){}
    protected void updateStoredToken(TokenIdent p0, long p1){}
    protected void updateToken(TokenIdent p0, AbstractDelegationTokenSecretManager.DelegationTokenInformation p1){}
    public AbstractDelegationTokenSecretManager(long p0, long p1, long p2, long p3){}
    public DelegationKey[] getAllKeys(){ return null; }
    public String getTokenTrackingId(TokenIdent p0){ return null; }
    public TokenIdent cancelToken(Token<TokenIdent> p0, String p1){ return null; }
    public TokenIdent decodeTokenIdentifier(Token<TokenIdent> p0){ return null; }
    public boolean isRunning(){ return false; }
    public byte[] retrievePassword(TokenIdent p0){ return null; }
    public long renewToken(Token<TokenIdent> p0, String p1){ return 0; }
    public static SecretKey createSecretKey(byte[] p0){ return null; }
    public void addKey(DelegationKey p0){}
    public void addPersistedDelegationToken(TokenIdent p0, long p1){}
    public void reset(){}
    public void startThreads(){}
    public void stopThreads(){}
    public void verifyToken(TokenIdent p0, byte[] p1){}
    static public class DelegationTokenInformation
    {
        protected DelegationTokenInformation() {}
        public DelegationTokenInformation(long p0, byte[] p1){}
        public DelegationTokenInformation(long p0, byte[] p1, String p2){}
        public String getTrackingId(){ return null; }
        public long getRenewDate(){ return 0; }
    }
}
