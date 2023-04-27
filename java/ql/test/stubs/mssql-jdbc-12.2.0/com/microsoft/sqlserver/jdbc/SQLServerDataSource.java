// Generated automatically from com.microsoft.sqlserver.jdbc.SQLServerDataSource for testing purposes

package com.microsoft.sqlserver.jdbc;

import com.microsoft.sqlserver.jdbc.ISQLServerDataSource;
import com.microsoft.sqlserver.jdbc.SQLServerAccessTokenCallback;
import java.io.PrintWriter;
import java.io.Serializable;
import java.sql.Connection;
import java.util.logging.Logger;
import javax.naming.Reference;
import javax.naming.Referenceable;
import javax.sql.DataSource;
import org.ietf.jgss.GSSCredential;

public class SQLServerDataSource implements DataSource, ISQLServerDataSource, Referenceable, Serializable
{
    public <T> T unwrap(Class<T> p0){ return null; }
    public Connection getConnection(){ return null; }
    public Connection getConnection(String p0, String p1){ return null; }
    public GSSCredential getGSSCredentials(){ return null; }
    public Logger getParentLogger(){ return null; }
    public PrintWriter getLogWriter(){ return null; }
    public Reference getReference(){ return null; }
    public SQLServerAccessTokenCallback getAccessTokenCallback(){ return null; }
    public SQLServerDataSource(){}
    public String getAADSecurePrincipalId(){ return null; }
    public String getAccessToken(){ return null; }
    public String getApplicationIntent(){ return null; }
    public String getApplicationName(){ return null; }
    public String getAuthentication(){ return null; }
    public String getClientCertificate(){ return null; }
    public String getClientKey(){ return null; }
    public String getColumnEncryptionSetting(){ return null; }
    public String getDatabaseName(){ return null; }
    public String getDatetimeParameterType(){ return null; }
    public String getDescription(){ return null; }
    public String getDomain(){ return null; }
    public String getEnclaveAttestationProtocol(){ return null; }
    public String getEnclaveAttestationUrl(){ return null; }
    public String getEncrypt(){ return null; }
    public String getFailoverPartner(){ return null; }
    public String getHostNameInCertificate(){ return null; }
    public String getIPAddressPreference(){ return null; }
    public String getInstanceName(){ return null; }
    public String getJAASConfigurationName(){ return null; }
    public String getJASSConfigurationName(){ return null; }
    public String getKeyStoreAuthentication(){ return null; }
    public String getKeyStoreLocation(){ return null; }
    public String getKeyStorePrincipalId(){ return null; }
    public String getKeyVaultProviderClientId(){ return null; }
    public String getMSIClientId(){ return null; }
    public String getMaxResultBuffer(){ return null; }
    public String getPrepareMethod(){ return null; }
    public String getRealm(){ return null; }
    public String getResponseBuffering(){ return null; }
    public String getSSLProtocol(){ return null; }
    public String getSelectMethod(){ return null; }
    public String getServerCertificate(){ return null; }
    public String getServerName(){ return null; }
    public String getServerSpn(){ return null; }
    public String getSocketFactoryClass(){ return null; }
    public String getSocketFactoryConstructorArg(){ return null; }
    public String getTrustManagerClass(){ return null; }
    public String getTrustManagerConstructorArg(){ return null; }
    public String getTrustStore(){ return null; }
    public String getTrustStoreType(){ return null; }
    public String getURL(){ return null; }
    public String getUser(){ return null; }
    public String getWorkstationID(){ return null; }
    public String toString(){ return null; }
    public boolean getDelayLoadingLobs(){ return false; }
    public boolean getDisableStatementPooling(){ return false; }
    public boolean getEnablePrepareOnFirstPreparedStatementCall(){ return false; }
    public boolean getFIPS(){ return false; }
    public boolean getLastUpdateCount(){ return false; }
    public boolean getMultiSubnetFailover(){ return false; }
    public boolean getReplication(){ return false; }
    public boolean getSendStringParametersAsUnicode(){ return false; }
    public boolean getSendTemporalDataTypesAsStringForBulkCopy(){ return false; }
    public boolean getSendTimeAsDatetime(){ return false; }
    public boolean getServerNameAsACE(){ return false; }
    public boolean getTransparentNetworkIPResolution(){ return false; }
    public boolean getTrustServerCertificate(){ return false; }
    public boolean getUseBulkCopyForBatchInsert(){ return false; }
    public boolean getUseFmtOnly(){ return false; }
    public boolean getXopenStates(){ return false; }
    public boolean isWrapperFor(Class<? extends Object> p0){ return false; }
    public int getCancelQueryTimeout(){ return 0; }
    public int getConnectRetryCount(){ return 0; }
    public int getConnectRetryInterval(){ return 0; }
    public int getLockTimeout(){ return 0; }
    public int getLoginTimeout(){ return 0; }
    public int getMsiTokenCacheTtl(){ return 0; }
    public int getPacketSize(){ return 0; }
    public int getPortNumber(){ return 0; }
    public int getQueryTimeout(){ return 0; }
    public int getServerPreparedStatementDiscardThreshold(){ return 0; }
    public int getSocketTimeout(){ return 0; }
    public int getStatementPoolingCacheSize(){ return 0; }
    public void setAADSecurePrincipalId(String p0){}
    public void setAADSecurePrincipalSecret(String p0){}
    public void setAccessToken(String p0){}
    public void setAccessTokenCallback(SQLServerAccessTokenCallback p0){}
    public void setApplicationIntent(String p0){}
    public void setApplicationName(String p0){}
    public void setAuthentication(String p0){}
    public void setAuthenticationScheme(String p0){}
    public void setCancelQueryTimeout(int p0){}
    public void setClientCertificate(String p0){}
    public void setClientKey(String p0){}
    public void setClientKeyPassword(String p0){}
    public void setColumnEncryptionSetting(String p0){}
    public void setConnectRetryCount(int p0){}
    public void setConnectRetryInterval(int p0){}
    public void setDatabaseName(String p0){}
    public void setDatetimeParameterType(String p0){}
    public void setDelayLoadingLobs(boolean p0){}
    public void setDescription(String p0){}
    public void setDisableStatementPooling(boolean p0){}
    public void setDomain(String p0){}
    public void setEnablePrepareOnFirstPreparedStatementCall(boolean p0){}
    public void setEnclaveAttestationProtocol(String p0){}
    public void setEnclaveAttestationUrl(String p0){}
    public void setEncrypt(String p0){}
    public void setEncrypt(boolean p0){}
    public void setFIPS(boolean p0){}
    public void setFailoverPartner(String p0){}
    public void setGSSCredentials(GSSCredential p0){}
    public void setHostNameInCertificate(String p0){}
    public void setIPAddressPreference(String p0){}
    public void setInstanceName(String p0){}
    public void setIntegratedSecurity(boolean p0){}
    public void setJAASConfigurationName(String p0){}
    public void setJASSConfigurationName(String p0){}
    public void setKeyStoreAuthentication(String p0){}
    public void setKeyStoreLocation(String p0){}
    public void setKeyStorePrincipalId(String p0){}
    public void setKeyStoreSecret(String p0){}
    public void setKeyVaultProviderClientId(String p0){}
    public void setKeyVaultProviderClientKey(String p0){}
    public void setLastUpdateCount(boolean p0){}
    public void setLockTimeout(int p0){}
    public void setLogWriter(PrintWriter p0){}
    public void setLoginTimeout(int p0){}
    public void setMSIClientId(String p0){}
    public void setMaxResultBuffer(String p0){}
    public void setMsiTokenCacheTtl(int p0){}
    public void setMultiSubnetFailover(boolean p0){}
    public void setPacketSize(int p0){}
    public void setPassword(String p0){}
    public void setPortNumber(int p0){}
    public void setPrepareMethod(String p0){}
    public void setQueryTimeout(int p0){}
    public void setRealm(String p0){}
    public void setReplication(boolean p0){}
    public void setResponseBuffering(String p0){}
    public void setSSLProtocol(String p0){}
    public void setSelectMethod(String p0){}
    public void setSendStringParametersAsUnicode(boolean p0){}
    public void setSendTemporalDataTypesAsStringForBulkCopy(boolean p0){}
    public void setSendTimeAsDatetime(boolean p0){}
    public void setServerCertificate(String p0){}
    public void setServerName(String p0){}
    public void setServerNameAsACE(boolean p0){}
    public void setServerPreparedStatementDiscardThreshold(int p0){}
    public void setServerSpn(String p0){}
    public void setSocketFactoryClass(String p0){}
    public void setSocketFactoryConstructorArg(String p0){}
    public void setSocketTimeout(int p0){}
    public void setStatementPoolingCacheSize(int p0){}
    public void setTransparentNetworkIPResolution(boolean p0){}
    public void setTrustManagerClass(String p0){}
    public void setTrustManagerConstructorArg(String p0){}
    public void setTrustServerCertificate(boolean p0){}
    public void setTrustStore(String p0){}
    public void setTrustStorePassword(String p0){}
    public void setTrustStoreType(String p0){}
    public void setURL(String p0){}
    public void setUseBulkCopyForBatchInsert(boolean p0){}
    public void setUseFmtOnly(boolean p0){}
    public void setUser(String p0){}
    public void setWorkstationID(String p0){}
    public void setXopenStates(boolean p0){}
}
