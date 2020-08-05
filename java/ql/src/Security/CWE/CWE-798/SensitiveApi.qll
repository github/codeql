import java

/**
 * Holds if callable `c` from a standard Java API expects a password parameter at index `i`.
 */
predicate javaApiCallablePasswordParam(Callable c, int i) {
  exists(c.getParameter(i)) and
  javaApiCallablePasswordParam(c.getDeclaringType().getQualifiedName() + ";" +
      c.getStringSignature() + ";" + i)
}

private predicate javaApiCallablePasswordParam(string s) {
  // Auto-generated using an auxiliary query run on the JDK source code.
  s = "com.sun.crypto.provider.JceKeyStore;engineLoad(InputStream, char[]);1" or
  s = "com.sun.crypto.provider.JceKeyStore;engineGetKey(String, char[]);1" or
  s = "com.sun.crypto.provider.JceKeyStore;engineSetKeyEntry(String, Key, char[], Certificate[]);2" or
  s = "com.sun.crypto.provider.JceKeyStore;engineStore(OutputStream, char[]);1" or
  s = "com.sun.crypto.provider.JceKeyStore;getPreKeyedHash(char[]);0" or
  s = "com.sun.crypto.provider.KeyProtector;KeyProtector(char[]);0" or
  s = "com.sun.crypto.provider.PBKDF2KeyImpl;deriveKey(Mac, byte[], byte[], int, int);1" or
  s = "com.sun.crypto.provider.PBKDF2KeyImpl;getPasswordBytes(char[]);0" or
  s = "com.sun.istack.internal.tools.DefaultAuthenticator$AuthInfo;AuthInfo(URL, String, String);2" or
  s = "com.sun.net.httpserver.BasicAuthenticator;checkCredentials(String, String);1" or
  s = "com.sun.net.ssl.KeyManagerFactory;init(KeyStore, char[]);1" or
  s = "com.sun.net.ssl.KeyManagerFactorySpi;engineInit(KeyStore, char[]);1" or
  s = "com.sun.net.ssl.KeyManagerFactorySpiWrapper;engineInit(KeyStore, char[]);1" or
  s =
    "com.sun.org.apache.xml.internal.security.keys.keyresolver.implementations.PrivateKeyResolver;PrivateKeyResolver(KeyStore, char[]);1" or
  s =
    "com.sun.org.apache.xml.internal.security.keys.keyresolver.implementations.SecretKeyResolver;SecretKeyResolver(KeyStore, char[]);1" or
  s = "com.sun.rowset.JdbcRowSetImpl;JdbcRowSetImpl(String, String, String);2" or
  s = "com.sun.rowset.JdbcRowSetImpl;setPassword(String);0" or
  s = "com.sun.security.auth.module.JndiLoginModule;verifyPassword(String, String);1" or
  s = "com.sun.security.auth.module.JndiLoginModule;verifyPassword(String, String);0" or
  s = "com.sun.security.ntlm.Client;Client(String, String, String, String, char[]);4" or
  s = "com.sun.security.ntlm.NTLM;getP2(char[]);0" or
  s = "com.sun.security.ntlm.NTLM;getP1(char[]);0" or
  s =
    "com.sun.security.sasl.digest.DigestMD5Base;generateResponseValue(String, String, String, String, String, char[], byte[], byte[], int, byte[]);5" or
  s =
    "com.sun.security.sasl.digest.DigestMD5Server;generateResponseAuth(String, char[], byte[], int, byte[]);1" or
  s = "com.sun.tools.internal.ws.wscompile.AuthInfo;AuthInfo(URL, String, String);2" or
  s = "java.net.PasswordAuthentication;PasswordAuthentication(String, char[]);1" or
  s = "java.security.KeyStore;setKeyEntry(String, Key, char[], Certificate[]);2" or
  s = "java.security.KeyStore;store(OutputStream, char[]);1" or
  s = "java.security.KeyStore;getKey(String, char[]);1" or
  s = "java.security.KeyStore;load(InputStream, char[]);1" or
  s =
    "java.security.KeyStore$PasswordProtection;PasswordProtection(char[], String, AlgorithmParameterSpec);0" or
  s = "java.security.KeyStore$PasswordProtection;PasswordProtection(char[]);0" or
  s = "java.security.KeyStoreSpi;engineStore(OutputStream, char[]);1" or
  s = "java.security.KeyStoreSpi;engineLoad(InputStream, char[]);1" or
  s = "java.security.KeyStoreSpi;engineSetKeyEntry(String, Key, char[], Certificate[]);2" or
  s = "java.security.KeyStoreSpi;engineGetKey(String, char[]);1" or
  s = "java.sql.DriverManager;getConnection(String, String, String);2" or
  s = "javax.crypto.spec.PBEKeySpec;PBEKeySpec(char[], byte[], int);0" or
  s = "javax.crypto.spec.PBEKeySpec;PBEKeySpec(char[], byte[], int, int);0" or
  s = "javax.crypto.spec.PBEKeySpec;PBEKeySpec(char[]);0" or
  s = "javax.net.ssl.KeyManagerFactory;init(KeyStore, char[]);1" or
  s = "javax.net.ssl.KeyManagerFactorySpi;engineInit(KeyStore, char[]);1" or
  s = "javax.security.auth.callback.PasswordCallback;setPassword(char[]);0" or
  s = "javax.security.auth.kerberos.KerberosKey;KerberosKey(KerberosPrincipal, char[], String);1" or
  s = "javax.security.auth.kerberos.KeyImpl;KeyImpl(KerberosPrincipal, char[], String);1" or
  s = "javax.sql.ConnectionPoolDataSource;getPooledConnection(String, String);1" or
  s = "javax.sql.DataSource;getConnection(String, String);1" or
  s = "javax.sql.RowSet;setPassword(String);0" or
  s = "javax.sql.XADataSource;getXAConnection(String, String);1" or
  s = "sun.net.ftp.FtpClient;login(String, char[]);1" or
  s = "sun.net.ftp.FtpClient;login(String, char[], String);1" or
  s = "sun.net.ftp.impl.FtpClient;login(String, char[], String);1" or
  s = "sun.net.ftp.impl.FtpClient;login(String, char[]);1" or
  s = "sun.net.ftp.impl.FtpClient;tryLogin(String, char[]);1" or
  s = "sun.net.www.protocol.http.DigestAuthentication;encode(String, char[], MessageDigest);1" or
  s =
    "sun.net.www.protocol.http.DigestAuthentication;computeDigest(boolean, String, char[], String, String, String, String, String, String);2" or
  s = "sun.security.krb5.EncryptionKey;acquireSecretKey(char[], String, int, byte[]);0" or
  s = "sun.security.krb5.EncryptionKey;stringToKey(char[], String, byte[], int);0" or
  s = "sun.security.krb5.EncryptionKey;EncryptionKey(char[], String, String);0" or
  s = "sun.security.krb5.EncryptionKey;acquireSecretKeys(char[], String);0" or
  s =
    "sun.security.krb5.EncryptionKey;acquireSecretKey(PrincipalName, char[], int, SaltAndParams);1" or
  s = "sun.security.krb5.KrbAsRep;decryptUsingPassword(char[], KrbAsReq, PrincipalName);0" or
  s = "sun.security.krb5.internal.crypto.Aes128;stringToKey(char[], String, byte[]);0" or
  s = "sun.security.krb5.internal.crypto.Aes256;stringToKey(char[], String, byte[]);0" or
  s = "sun.security.krb5.internal.crypto.ArcFourHmac;stringToKey(char[]);0" or
  s = "sun.security.krb5.internal.crypto.Des;char_to_key(char[]);0" or
  s = "sun.security.krb5.internal.crypto.Des;string_to_key_bytes(char[]);0" or
  s = "sun.security.krb5.internal.crypto.dk.AesDkCrypto;stringToKey(char[], String, byte[]);0" or
  s = "sun.security.krb5.internal.crypto.dk.ArcFourCrypto;stringToKey(char[]);0" or
  s = "sun.security.pkcs11.P11KeyStore;engineLoad(InputStream, char[]);1" or
  s = "sun.security.pkcs11.P11KeyStore;engineGetKey(String, char[]);1" or
  s = "sun.security.pkcs11.P11KeyStore;engineStore(OutputStream, char[]);1" or
  s = "sun.security.pkcs11.P11KeyStore;engineSetKeyEntry(String, Key, char[], Certificate[]);2" or
  s = "sun.security.pkcs11.P11KeyStore$PasswordCallbackHandler;PasswordCallbackHandler(char[]);0" or
  s = "sun.security.pkcs11.Secmod$KeyStoreLoadParameter;KeyStoreLoadParameter(TrustType, char[]);1" or
  s = "sun.security.pkcs12.PKCS12KeyStore;engineGetKey(String, char[]);1" or
  s = "sun.security.pkcs12.PKCS12KeyStore;calculateMac(char[], byte[]);0" or
  s = "sun.security.pkcs12.PKCS12KeyStore;encryptContent(byte[], char[]);1" or
  s = "sun.security.pkcs12.PKCS12KeyStore;loadSafeContents(DerInputStream, char[]);1" or
  s = "sun.security.pkcs12.PKCS12KeyStore;engineSetKeyEntry(String, Key, char[], Certificate[]);2" or
  s = "sun.security.pkcs12.PKCS12KeyStore;engineStore(OutputStream, char[]);1" or
  s = "sun.security.pkcs12.PKCS12KeyStore;engineLoad(InputStream, char[]);1" or
  s = "sun.security.pkcs12.PKCS12KeyStore;getPBEKey(char[]);0" or
  s = "sun.security.pkcs12.PKCS12KeyStore;createEncryptedData(char[]);0" or
  s = "sun.security.provider.DomainKeyStore;engineGetKey(String, char[]);1" or
  s = "sun.security.provider.DomainKeyStore;engineSetKeyEntry(String, Key, char[], Certificate[]);2" or
  s = "sun.security.provider.DomainKeyStore;engineStore(OutputStream, char[]);1" or
  s = "sun.security.provider.DomainKeyStore;engineLoad(InputStream, char[]);1" or
  s = "sun.security.provider.JavaKeyStore;engineSetKeyEntry(String, Key, char[], Certificate[]);2" or
  s = "sun.security.provider.JavaKeyStore;engineLoad(InputStream, char[]);1" or
  s = "sun.security.provider.JavaKeyStore;getPreKeyedHash(char[]);0" or
  s = "sun.security.provider.JavaKeyStore;engineGetKey(String, char[]);1" or
  s = "sun.security.provider.JavaKeyStore;engineStore(OutputStream, char[]);1" or
  s = "sun.security.provider.KeyProtector;KeyProtector(char[]);0" or
  s = "sun.security.ssl.KeyManagerFactoryImpl$SunX509;engineInit(KeyStore, char[]);1" or
  s = "sun.security.ssl.KeyManagerFactoryImpl$X509;engineInit(KeyStore, char[]);1" or
  s = "sun.security.ssl.SunX509KeyManagerImpl;SunX509KeyManagerImpl(KeyStore, char[]);1" or
  s = "sun.security.tools.keytool.Main;getNewPasswd(String, char[]);1" or
  s =
    "sun.tools.jconsole.ConnectDialog;setConnectionParameters(String, String, int, String, String, String);4" or
  s = "sun.tools.jconsole.JConsole;addHost(String, int, String, String);3" or
  s = "sun.tools.jconsole.JConsole;addUrl(String, String, String, boolean);2" or
  s = "sun.tools.jconsole.JConsole;addHost(String, int, String, String, boolean);3" or
  s = "sun.tools.jconsole.JConsole;showConnectDialog(String, String, int, String, String, String);4" or
  s = "sun.tools.jconsole.JConsole;failed(Exception, String, String, String);3" or
  s = "sun.tools.jconsole.ProxyClient;getCacheKey(String, String, String);2" or
  s = "sun.tools.jconsole.ProxyClient;setParameters(JMXServiceURL, String, String);2" or
  s = "sun.tools.jconsole.ProxyClient;ProxyClient(String, String, String);2" or
  s = "sun.tools.jconsole.ProxyClient;ProxyClient(String, int, String, String);3" or
  s = "sun.tools.jconsole.ProxyClient;getProxyClient(String, int, String, String);3" or
  s = "sun.tools.jconsole.ProxyClient;getProxyClient(String, String, String);2" or
  s = "sun.tools.jconsole.ProxyClient;getCacheKey(String, int, String, String);3" or
  s = "com.amazonaws.auth.BasicAWSCredentials;BasicAWSCredentials(String, String);1"
}

/**
 * Holds if callable `c` from a standard Java API expects a username parameter at index `i`.
 */
predicate javaApiCallableUsernameParam(Callable c, int i) {
  exists(c.getParameter(i)) and
  javaApiCallableUsernameParam(c.getDeclaringType().getQualifiedName() + ";" +
      c.getStringSignature() + ";" + i)
}

private predicate javaApiCallableUsernameParam(string s) {
  // Auto-generated using an auxiliary query run on the JDK source code.
  s = "com.sun.istack.internal.tools.DefaultAuthenticator$AuthInfo;AuthInfo(URL, String, String);1" or
  s =
    "com.sun.jndi.ldap.DigestClientId;DigestClientId(int, String, int, String, Control[], OutputStream, String, String, Object, Hashtable<?,?>);7" or
  s =
    "com.sun.jndi.ldap.LdapClient;getInstance(boolean, String, int, String, int, int, OutputStream, int, String, Control[], String, String, Object, Hashtable<?,?>);11" or
  s =
    "com.sun.jndi.ldap.LdapPoolManager;getLdapClient(String, int, String, int, int, OutputStream, int, String, Control[], String, String, Object, Hashtable<?,?>);10" or
  s =
    "com.sun.jndi.ldap.SimpleClientId;SimpleClientId(int, String, int, String, Control[], OutputStream, String, String, Object);7" or
  s = "com.sun.net.httpserver.BasicAuthenticator;checkCredentials(String, String);0" or
  s = "com.sun.net.httpserver.HttpPrincipal;HttpPrincipal(String, String);0" or
  s = "com.sun.rowset.JdbcRowSetImpl;JdbcRowSetImpl(String, String, String);1" or
  s = "com.sun.security.ntlm.Client;Client(String, String, String, String, char[]);2" or
  s = "com.sun.security.ntlm.Server;getPassword(String, String);1" or
  s =
    "com.sun.security.sasl.digest.DigestMD5Server;generateResponseAuth(String, char[], byte[], int, byte[]);0" or
  s = "com.sun.tools.internal.ws.wscompile.AuthInfo;AuthInfo(URL, String, String);1" or
  s = "java.net.PasswordAuthentication;PasswordAuthentication(String, char[]);0" or
  s = "java.sql.DriverManager;getConnection(String, String, String);1" or
  s =
    "javax.print.attribute.standard.JobOriginatingUserName;JobOriginatingUserName(String, Locale);0" or
  s = "javax.print.attribute.standard.RequestingUserName;RequestingUserName(String, Locale);0" or
  s = "javax.sql.ConnectionPoolDataSource;getPooledConnection(String, String);0" or
  s = "javax.sql.DataSource;getConnection(String, String);0" or
  s = "javax.sql.XADataSource;getXAConnection(String, String);0" or
  s = "sun.jvmstat.perfdata.monitor.protocol.local.LocalVmManager;LocalVmManager(String);0" or
  s = "sun.jvmstat.perfdata.monitor.protocol.local.PerfDataFile;getFile(String, int);0" or
  s = "sun.jvmstat.perfdata.monitor.protocol.local.PerfDataFile;getTempDirectory(String);0" or
  s =
    "sun.jvmstat.perfdata.monitor.protocol.rmi.RemoteVmManager;RemoteVmManager(RemoteHost, String);1" or
  s = "sun.misc.Perf;attach(String, int, int);0" or
  s = "sun.misc.Perf;attach(String, int, String);0" or
  s = "sun.misc.Perf;attachImpl(String, int, int);0" or
  s = "sun.net.ftp.FtpClient;login(String, char[], String);0" or
  s = "sun.net.ftp.FtpClient;login(String, char[]);0" or
  s = "sun.net.ftp.FtpDirEntry;setUser(String);0" or
  s = "sun.net.ftp.impl.FtpClient;login(String, char[], String);0" or
  s = "sun.net.ftp.impl.FtpClient;tryLogin(String, char[]);0" or
  s = "sun.net.ftp.impl.FtpClient;login(String, char[]);0" or
  s =
    "sun.net.www.protocol.http.DigestAuthentication;computeDigest(boolean, String, char[], String, String, String, String, String, String);1" or
  s = "sun.security.acl.PrincipalImpl;PrincipalImpl(String);0" or
  s =
    "sun.tools.jconsole.ConnectDialog;setConnectionParameters(String, String, int, String, String, String);3" or
  s = "sun.tools.jconsole.JConsole;failed(Exception, String, String, String);2" or
  s = "sun.tools.jconsole.JConsole;addHost(String, int, String, String, boolean);2" or
  s = "sun.tools.jconsole.JConsole;addUrl(String, String, String, boolean);1" or
  s = "sun.tools.jconsole.JConsole;addHost(String, int, String, String);2" or
  s = "sun.tools.jconsole.JConsole;showConnectDialog(String, String, int, String, String, String);3" or
  s = "sun.tools.jconsole.ProxyClient;ProxyClient(String, String, String);1" or
  s = "sun.tools.jconsole.ProxyClient;ProxyClient(String, int, String, String);2" or
  s = "sun.tools.jconsole.ProxyClient;setParameters(JMXServiceURL, String, String);1" or
  s = "sun.tools.jconsole.ProxyClient;getCacheKey(String, String, String);1" or
  s = "sun.tools.jconsole.ProxyClient;getCacheKey(String, int, String, String);2" or
  s = "sun.tools.jconsole.ProxyClient;getProxyClient(String, String, String);1" or
  s = "sun.tools.jconsole.ProxyClient;getConnectionName(String, String);1" or
  s = "sun.tools.jconsole.ProxyClient;getProxyClient(String, int, String, String);2" or
  s = "sun.tools.jconsole.ProxyClient;getConnectionName(String, int, String);2" or
  s = "com.amazonaws.auth.BasicAWSCredentials;BasicAWSCredentials(String, String);0"
}

/**
 * Holds if callable `c` from a standard Java API expects a cryptographic key parameter at index `i`.
 */
predicate javaApiCallableCryptoKeyParam(Callable c, int i) {
  exists(c.getParameter(i)) and
  javaApiCallableCryptoKeyParam(c.getDeclaringType().getQualifiedName() + ";" +
      c.getStringSignature() + ";" + i)
}

private predicate javaApiCallableCryptoKeyParam(string s) {
  // Auto-generated using an auxiliary query run on the JDK source code.
  s = "com.sun.crypto.provider.AESCipher;engineUnwrap(byte[], String, int);0" or
  s = "com.sun.crypto.provider.AESCrypt;init(boolean, String, byte[]);2" or
  s = "com.sun.crypto.provider.AESWrapCipher;engineUnwrap(byte[], String, int);0" or
  s = "com.sun.crypto.provider.ARCFOURCipher;init(byte[]);0" or
  s = "com.sun.crypto.provider.ARCFOURCipher;engineUnwrap(byte[], String, int);0" or
  s = "com.sun.crypto.provider.BlowfishCipher;engineUnwrap(byte[], String, int);0" or
  s = "com.sun.crypto.provider.BlowfishCrypt;init(boolean, String, byte[]);2" or
  s = "com.sun.crypto.provider.CipherBlockChaining;init(boolean, String, byte[], byte[]);2" or
  s = "com.sun.crypto.provider.CipherCore;unwrap(byte[], String, int);0" or
  s = "com.sun.crypto.provider.CipherFeedback;init(boolean, String, byte[], byte[]);2" or
  s = "com.sun.crypto.provider.CipherWithWrappingSpi;constructPublicKey(byte[], String);0" or
  s = "com.sun.crypto.provider.CipherWithWrappingSpi;engineUnwrap(byte[], String, int);0" or
  s = "com.sun.crypto.provider.CipherWithWrappingSpi;constructSecretKey(byte[], String);0" or
  s = "com.sun.crypto.provider.CipherWithWrappingSpi;constructPrivateKey(byte[], String);0" or
  s = "com.sun.crypto.provider.ConstructKeys;constructPrivateKey(byte[], String);0" or
  s = "com.sun.crypto.provider.ConstructKeys;constructSecretKey(byte[], String);0" or
  s = "com.sun.crypto.provider.ConstructKeys;constructPublicKey(byte[], String);0" or
  s = "com.sun.crypto.provider.CounterMode;init(boolean, String, byte[], byte[]);2" or
  s = "com.sun.crypto.provider.DESCipher;engineUnwrap(byte[], String, int);0" or
  s = "com.sun.crypto.provider.DESCrypt;expandKey(byte[]);0" or
  s = "com.sun.crypto.provider.DESCrypt;init(boolean, String, byte[]);2" or
  s = "com.sun.crypto.provider.DESKey;DESKey(byte[], int);0" or
  s = "com.sun.crypto.provider.DESKey;DESKey(byte[]);0" or
  s = "com.sun.crypto.provider.DESKeyGenerator;setParityBit(byte[], int);0" or
  s = "com.sun.crypto.provider.DESedeCipher;engineUnwrap(byte[], String, int);0" or
  s = "com.sun.crypto.provider.DESedeKey;DESedeKey(byte[], int);0" or
  s = "com.sun.crypto.provider.DESedeKey;DESedeKey(byte[]);0" or
  s = "com.sun.crypto.provider.DESedeWrapCipher;engineUnwrap(byte[], String, int);0" or
  s = "com.sun.crypto.provider.DHPrivateKey;DHPrivateKey(byte[]);0" or
  s = "com.sun.crypto.provider.DHPublicKey;DHPublicKey(byte[]);0" or
  s = "com.sun.crypto.provider.ElectronicCodeBook;init(boolean, String, byte[], byte[]);2" or
  s = "com.sun.crypto.provider.FeedbackCipher;init(boolean, String, byte[], byte[]);2" or
  s = "com.sun.crypto.provider.GaloisCounterMode;init(boolean, String, byte[], byte[]);2" or
  s = "com.sun.crypto.provider.GaloisCounterMode;init(boolean, String, byte[], byte[], int);2" or
  s = "com.sun.crypto.provider.JceKeyStore;engineSetKeyEntry(String, byte[], Certificate[]);1" or
  s = "com.sun.crypto.provider.KeyProtector;recover(byte[]);0" or
  s = "com.sun.crypto.provider.OutputFeedback;init(boolean, String, byte[], byte[]);2" or
  s = "com.sun.crypto.provider.PBECipherCore;unwrap(byte[], String, int);0" or
  s = "com.sun.crypto.provider.PBES1Core;unwrap(byte[], String, int);0" or
  s = "com.sun.crypto.provider.PBES2Core;engineUnwrap(byte[], String, int);0" or
  s = "com.sun.crypto.provider.PBEWithMD5AndDESCipher;engineUnwrap(byte[], String, int);0" or
  s = "com.sun.crypto.provider.PBEWithMD5AndTripleDESCipher;engineUnwrap(byte[], String, int);0" or
  s = "com.sun.crypto.provider.PCBC;init(boolean, String, byte[], byte[]);2" or
  s = "com.sun.crypto.provider.PKCS12PBECipherCore;implUnwrap(byte[], String, int);0" or
  s =
    "com.sun.crypto.provider.PKCS12PBECipherCore$PBEWithSHA1AndDESede;engineUnwrap(byte[], String, int);0" or
  s =
    "com.sun.crypto.provider.PKCS12PBECipherCore$PBEWithSHA1AndRC2_128;engineUnwrap(byte[], String, int);0" or
  s =
    "com.sun.crypto.provider.PKCS12PBECipherCore$PBEWithSHA1AndRC2_40;engineUnwrap(byte[], String, int);0" or
  s =
    "com.sun.crypto.provider.PKCS12PBECipherCore$PBEWithSHA1AndRC4_128;engineUnwrap(byte[], String, int);0" or
  s =
    "com.sun.crypto.provider.PKCS12PBECipherCore$PBEWithSHA1AndRC4_40;engineUnwrap(byte[], String, int);0" or
  s = "com.sun.crypto.provider.RC2Cipher;engineUnwrap(byte[], String, int);0" or
  s = "com.sun.crypto.provider.RC2Crypt;init(boolean, String, byte[]);2" or
  s = "com.sun.crypto.provider.RSACipher;engineUnwrap(byte[], String, int);0" or
  s = "com.sun.crypto.provider.SymmetricCipher;init(boolean, String, byte[]);2" or
  s =
    "com.sun.crypto.provider.TlsMasterSecretGenerator$TlsMasterSecretKey;TlsMasterSecretKey(byte[], int, int);0" or
  s = "java.security.KeyStore;setKeyEntry(String, byte[], Certificate[]);1" or
  s = "java.security.KeyStoreSpi;engineSetKeyEntry(String, byte[], Certificate[]);1" or
  s = "java.security.cert.X509CertSelector;setSubjectPublicKey(byte[]);0" or
  s = "java.security.spec.EncodedKeySpec;EncodedKeySpec(byte[]);0" or
  s = "java.security.spec.PKCS8EncodedKeySpec;PKCS8EncodedKeySpec(byte[]);0" or
  s = "java.security.spec.X509EncodedKeySpec;X509EncodedKeySpec(byte[]);0" or
  s = "javax.crypto.Cipher;unwrap(byte[], String, int);0" or
  s = "javax.crypto.CipherSpi;engineUnwrap(byte[], String, int);0" or
  s = "javax.crypto.EncryptedPrivateKeyInfo;checkPKCS8Encoding(byte[]);0" or
  s = "javax.crypto.spec.DESKeySpec;isWeak(byte[], int);0" or
  s = "javax.crypto.spec.DESKeySpec;DESKeySpec(byte[], int);0" or
  s = "javax.crypto.spec.DESKeySpec;isParityAdjusted(byte[], int);0" or
  s = "javax.crypto.spec.DESKeySpec;DESKeySpec(byte[]);0" or
  s = "javax.crypto.spec.DESedeKeySpec;isParityAdjusted(byte[], int);0" or
  s = "javax.crypto.spec.DESedeKeySpec;DESedeKeySpec(byte[], int);0" or
  s = "javax.crypto.spec.DESedeKeySpec;DESedeKeySpec(byte[]);0" or
  s = "javax.crypto.spec.SecretKeySpec;SecretKeySpec(byte[], String);0" or
  s = "javax.crypto.spec.SecretKeySpec;SecretKeySpec(byte[], int, int, String);0" or
  s = "javax.security.auth.kerberos.KerberosKey;KerberosKey(KerberosPrincipal, byte[], int, int);1" or
  s =
    "javax.security.auth.kerberos.KerberosTicket;KerberosTicket(byte[], KerberosPrincipal, KerberosPrincipal, byte[], int, boolean[], Date, Date, Date, Date, InetAddress[]);3" or
  s =
    "javax.security.auth.kerberos.KerberosTicket;init(byte[], KerberosPrincipal, KerberosPrincipal, byte[], int, boolean[], Date, Date, Date, Date, InetAddress[]);3" or
  s = "javax.security.auth.kerberos.KeyImpl;KeyImpl(byte[], int);0" or
  s = "sun.security.jgss.krb5.CipherHelper;getInitializedDes(boolean, byte[], byte[]);1" or
  s = "sun.security.jgss.krb5.CipherHelper;getDesCbcChecksum(byte[], byte[], byte[], int, int);0" or
  s = "sun.security.jgss.krb5.CipherHelper;getDesEncryptionKey(byte[]);0" or
  s =
    "sun.security.jgss.krb5.CipherHelper;desCbcDecrypt(WrapToken, byte[], byte[], int, int, byte[], int);1" or
  s =
    "sun.security.jgss.krb5.CipherHelper;desCbcDecrypt(WrapToken, byte[], InputStream, int, byte[], int);1" or
  s =
    "sun.security.jgss.krb5.Krb5InitCredential;Krb5InitCredential(Krb5NameElement, byte[], KerberosPrincipal, KerberosPrincipal, byte[], int, boolean[], Date, Date, Date, Date, InetAddress[]);4" or
  s =
    "sun.security.jgss.krb5.Krb5InitCredential;Krb5InitCredential(Krb5NameElement, Credentials, byte[], KerberosPrincipal, KerberosPrincipal, byte[], int, boolean[], Date, Date, Date, Date, InetAddress[]);5" or
  s =
    "sun.security.krb5.Credentials;Credentials(byte[], String, String, byte[], int, boolean[], Date, Date, Date, Date, InetAddress[]);3" or
  s = "sun.security.krb5.EncryptionKey;EncryptionKey(int, byte[]);1" or
  s = "sun.security.krb5.EncryptionKey;EncryptionKey(byte[], int, Integer);0" or
  s = "sun.security.krb5.internal.crypto.Aes128;decryptRaw(byte[], int, byte[], byte[], int, int);0" or
  s = "sun.security.krb5.internal.crypto.Aes128;calculateChecksum(byte[], int, byte[], int, int);0" or
  s = "sun.security.krb5.internal.crypto.Aes128;decrypt(byte[], int, byte[], byte[], int, int);0" or
  s = "sun.security.krb5.internal.crypto.Aes128;encryptRaw(byte[], int, byte[], byte[], int, int);0" or
  s = "sun.security.krb5.internal.crypto.Aes128;encrypt(byte[], int, byte[], byte[], int, int);0" or
  s =
    "sun.security.krb5.internal.crypto.Aes128CtsHmacSha1EType;encrypt(byte[], byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.Aes128CtsHmacSha1EType;decrypt(byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.Aes128CtsHmacSha1EType;encrypt(byte[], byte[], int);1" or
  s =
    "sun.security.krb5.internal.crypto.Aes128CtsHmacSha1EType;decrypt(byte[], byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.Aes256;encrypt(byte[], int, byte[], byte[], int, int);0" or
  s = "sun.security.krb5.internal.crypto.Aes256;decryptRaw(byte[], int, byte[], byte[], int, int);0" or
  s = "sun.security.krb5.internal.crypto.Aes256;calculateChecksum(byte[], int, byte[], int, int);0" or
  s = "sun.security.krb5.internal.crypto.Aes256;encryptRaw(byte[], int, byte[], byte[], int, int);0" or
  s = "sun.security.krb5.internal.crypto.Aes256;decrypt(byte[], int, byte[], byte[], int, int);0" or
  s =
    "sun.security.krb5.internal.crypto.Aes256CtsHmacSha1EType;encrypt(byte[], byte[], byte[], int);1" or
  s =
    "sun.security.krb5.internal.crypto.Aes256CtsHmacSha1EType;decrypt(byte[], byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.Aes256CtsHmacSha1EType;decrypt(byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.Aes256CtsHmacSha1EType;encrypt(byte[], byte[], int);1" or
  s =
    "sun.security.krb5.internal.crypto.ArcFourHmac;encryptRaw(byte[], int, byte[], byte[], int, int);0" or
  s =
    "sun.security.krb5.internal.crypto.ArcFourHmac;decryptRaw(byte[], int, byte[], byte[], int, int, byte[]);0" or
  s =
    "sun.security.krb5.internal.crypto.ArcFourHmac;decrypt(byte[], int, byte[], byte[], int, int);0" or
  s =
    "sun.security.krb5.internal.crypto.ArcFourHmac;decryptSeq(byte[], int, byte[], byte[], int, int);0" or
  s =
    "sun.security.krb5.internal.crypto.ArcFourHmac;encrypt(byte[], int, byte[], byte[], int, int);0" or
  s =
    "sun.security.krb5.internal.crypto.ArcFourHmac;calculateChecksum(byte[], int, byte[], int, int);0" or
  s =
    "sun.security.krb5.internal.crypto.ArcFourHmac;encryptSeq(byte[], int, byte[], byte[], int, int);0" or
  s = "sun.security.krb5.internal.crypto.ArcFourHmacEType;decrypt(byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.ArcFourHmacEType;encrypt(byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.ArcFourHmacEType;decrypt(byte[], byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.ArcFourHmacEType;encrypt(byte[], byte[], byte[], int);1" or
  s =
    "sun.security.krb5.internal.crypto.CksumType;calculateKeyedChecksum(byte[], int, byte[], int);2" or
  s =
    "sun.security.krb5.internal.crypto.CksumType;verifyKeyedChecksum(byte[], int, byte[], byte[], int);2" or
  s =
    "sun.security.krb5.internal.crypto.Crc32CksumType;verifyKeyedChecksum(byte[], int, byte[], byte[], int);2" or
  s =
    "sun.security.krb5.internal.crypto.Crc32CksumType;calculateKeyedChecksum(byte[], int, byte[], int);2" or
  s = "sun.security.krb5.internal.crypto.Des;cbc_encrypt(byte[], byte[], byte[], byte[], boolean);2" or
  s = "sun.security.krb5.internal.crypto.Des;set_parity(byte[]);0" or
  s = "sun.security.krb5.internal.crypto.Des;bad_key(byte[]);0" or
  s = "sun.security.krb5.internal.crypto.Des;des_cksum(byte[], byte[], byte[]);2" or
  s = "sun.security.krb5.internal.crypto.Des3;decryptRaw(byte[], int, byte[], byte[], int, int);0" or
  s = "sun.security.krb5.internal.crypto.Des3;encrypt(byte[], int, byte[], byte[], int, int);0" or
  s = "sun.security.krb5.internal.crypto.Des3;encryptRaw(byte[], int, byte[], byte[], int, int);0" or
  s = "sun.security.krb5.internal.crypto.Des3;decrypt(byte[], int, byte[], byte[], int, int);0" or
  s = "sun.security.krb5.internal.crypto.Des3;calculateChecksum(byte[], int, byte[], int, int);0" or
  s = "sun.security.krb5.internal.crypto.Des3CbcHmacSha1KdEType;encrypt(byte[], byte[], int);1" or
  s =
    "sun.security.krb5.internal.crypto.Des3CbcHmacSha1KdEType;encrypt(byte[], byte[], byte[], int);1" or
  s =
    "sun.security.krb5.internal.crypto.Des3CbcHmacSha1KdEType;decrypt(byte[], byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.Des3CbcHmacSha1KdEType;decrypt(byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.DesCbcCrcEType;decrypt(byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.DesCbcCrcEType;encrypt(byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.DesCbcEType;encrypt(byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.DesCbcEType;decrypt(byte[], byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.DesCbcEType;encrypt(byte[], byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.DesCbcEType;decrypt(byte[], byte[], int);1" or
  s =
    "sun.security.krb5.internal.crypto.DesMacCksumType;calculateKeyedChecksum(byte[], int, byte[], int);2" or
  s = "sun.security.krb5.internal.crypto.DesMacCksumType;decryptKeyedChecksum(byte[], byte[]);1" or
  s =
    "sun.security.krb5.internal.crypto.DesMacCksumType;verifyKeyedChecksum(byte[], int, byte[], byte[], int);2" or
  s =
    "sun.security.krb5.internal.crypto.DesMacKCksumType;calculateKeyedChecksum(byte[], int, byte[], int);2" or
  s =
    "sun.security.krb5.internal.crypto.DesMacKCksumType;verifyKeyedChecksum(byte[], int, byte[], byte[], int);2" or
  s = "sun.security.krb5.internal.crypto.EType;encrypt(byte[], byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.EType;decrypt(byte[], byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.EType;decrypt(byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.EType;encrypt(byte[], byte[], int);1" or
  s =
    "sun.security.krb5.internal.crypto.HmacMd5ArcFourCksumType;verifyKeyedChecksum(byte[], int, byte[], byte[], int);2" or
  s =
    "sun.security.krb5.internal.crypto.HmacMd5ArcFourCksumType;calculateKeyedChecksum(byte[], int, byte[], int);2" or
  s =
    "sun.security.krb5.internal.crypto.HmacSha1Aes128CksumType;verifyKeyedChecksum(byte[], int, byte[], byte[], int);2" or
  s =
    "sun.security.krb5.internal.crypto.HmacSha1Aes128CksumType;calculateKeyedChecksum(byte[], int, byte[], int);2" or
  s =
    "sun.security.krb5.internal.crypto.HmacSha1Aes256CksumType;verifyKeyedChecksum(byte[], int, byte[], byte[], int);2" or
  s =
    "sun.security.krb5.internal.crypto.HmacSha1Aes256CksumType;calculateKeyedChecksum(byte[], int, byte[], int);2" or
  s =
    "sun.security.krb5.internal.crypto.HmacSha1Des3KdCksumType;calculateKeyedChecksum(byte[], int, byte[], int);2" or
  s =
    "sun.security.krb5.internal.crypto.HmacSha1Des3KdCksumType;verifyKeyedChecksum(byte[], int, byte[], byte[], int);2" or
  s = "sun.security.krb5.internal.crypto.NullEType;decrypt(byte[], byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.NullEType;decrypt(byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.NullEType;encrypt(byte[], byte[], byte[], int);1" or
  s = "sun.security.krb5.internal.crypto.NullEType;encrypt(byte[], byte[], int);1" or
  s =
    "sun.security.krb5.internal.crypto.RsaMd5CksumType;verifyKeyedChecksum(byte[], int, byte[], byte[], int);2" or
  s =
    "sun.security.krb5.internal.crypto.RsaMd5CksumType;calculateKeyedChecksum(byte[], int, byte[], int);2" or
  s = "sun.security.krb5.internal.crypto.RsaMd5DesCksumType;decryptKeyedChecksum(byte[], byte[]);1" or
  s =
    "sun.security.krb5.internal.crypto.RsaMd5DesCksumType;verifyKeyedChecksum(byte[], int, byte[], byte[], int);2" or
  s =
    "sun.security.krb5.internal.crypto.RsaMd5DesCksumType;calculateKeyedChecksum(byte[], int, byte[], int);2" or
  s =
    "sun.security.krb5.internal.crypto.dk.AesDkCrypto;encryptCTS(byte[], int, byte[], byte[], byte[], int, int, boolean);0" or
  s =
    "sun.security.krb5.internal.crypto.dk.AesDkCrypto;decrypt(byte[], int, byte[], byte[], int, int);0" or
  s =
    "sun.security.krb5.internal.crypto.dk.AesDkCrypto;encryptRaw(byte[], int, byte[], byte[], int, int);0" or
  s =
    "sun.security.krb5.internal.crypto.dk.AesDkCrypto;calculateChecksum(byte[], int, byte[], int, int);0" or
  s =
    "sun.security.krb5.internal.crypto.dk.AesDkCrypto;encrypt(byte[], int, byte[], byte[], byte[], int, int);0" or
  s = "sun.security.krb5.internal.crypto.dk.AesDkCrypto;getHmac(byte[], byte[]);0" or
  s = "sun.security.krb5.internal.crypto.dk.AesDkCrypto;getCipher(byte[], byte[], int);0" or
  s =
    "sun.security.krb5.internal.crypto.dk.AesDkCrypto;decryptRaw(byte[], int, byte[], byte[], int, int);0" or
  s =
    "sun.security.krb5.internal.crypto.dk.AesDkCrypto;decryptCTS(byte[], int, byte[], byte[], int, int, boolean);0" or
  s =
    "sun.security.krb5.internal.crypto.dk.ArcFourCrypto;decryptSeq(byte[], int, byte[], byte[], int, int);0" or
  s =
    "sun.security.krb5.internal.crypto.dk.ArcFourCrypto;decryptRaw(byte[], int, byte[], byte[], int, int, byte[]);0" or
  s =
    "sun.security.krb5.internal.crypto.dk.ArcFourCrypto;decrypt(byte[], int, byte[], byte[], int, int);0" or
  s =
    "sun.security.krb5.internal.crypto.dk.ArcFourCrypto;encryptRaw(byte[], int, byte[], byte[], int, int);0" or
  s = "sun.security.krb5.internal.crypto.dk.ArcFourCrypto;getCipher(byte[], byte[], int);0" or
  s =
    "sun.security.krb5.internal.crypto.dk.ArcFourCrypto;encryptSeq(byte[], int, byte[], byte[], int, int);0" or
  s =
    "sun.security.krb5.internal.crypto.dk.ArcFourCrypto;calculateChecksum(byte[], int, byte[], int, int);0" or
  s =
    "sun.security.krb5.internal.crypto.dk.ArcFourCrypto;encrypt(byte[], int, byte[], byte[], byte[], int, int);0" or
  s = "sun.security.krb5.internal.crypto.dk.ArcFourCrypto;getHmac(byte[], byte[]);0" or
  s = "sun.security.krb5.internal.crypto.dk.Des3DkCrypto;keyCorrection(byte[]);0" or
  s = "sun.security.krb5.internal.crypto.dk.Des3DkCrypto;getCipher(byte[], byte[], int);0" or
  s = "sun.security.krb5.internal.crypto.dk.Des3DkCrypto;getHmac(byte[], byte[]);0" or
  s = "sun.security.krb5.internal.crypto.dk.Des3DkCrypto;setParityBit(byte[]);0" or
  s =
    "sun.security.krb5.internal.crypto.dk.DkCrypto;encrypt(byte[], int, byte[], byte[], byte[], int, int);0" or
  s =
    "sun.security.krb5.internal.crypto.dk.DkCrypto;decrypt(byte[], int, byte[], byte[], int, int);0" or
  s =
    "sun.security.krb5.internal.crypto.dk.DkCrypto;encryptRaw(byte[], int, byte[], byte[], int, int);0" or
  s =
    "sun.security.krb5.internal.crypto.dk.DkCrypto;calculateChecksum(byte[], int, byte[], int, int);0" or
  s =
    "sun.security.krb5.internal.crypto.dk.DkCrypto;decryptRaw(byte[], int, byte[], byte[], int, int);0" or
  s = "sun.security.krb5.internal.crypto.dk.DkCrypto;getHmac(byte[], byte[]);0" or
  s = "sun.security.krb5.internal.crypto.dk.DkCrypto;getCipher(byte[], byte[], int);0" or
  s = "sun.security.krb5.internal.crypto.dk.DkCrypto;dk(byte[], byte[]);0" or
  s = "sun.security.krb5.internal.crypto.dk.DkCrypto;dr(byte[], byte[]);0" or
  s = "sun.security.pkcs.PKCS8Key;decode(byte[]);0" or
  s = "sun.security.pkcs.PKCS8Key;PKCS8Key(AlgorithmId, byte[]);1" or
  s = "sun.security.pkcs.PKCS8Key;buildPKCS8Key(AlgorithmId, byte[]);1" or
  s = "sun.security.pkcs.PKCS8Key;encode(DerOutputStream, AlgorithmId, byte[]);2" or
  s = "sun.security.pkcs11.ConstructKeys;constructPublicKey(byte[], String);0" or
  s = "sun.security.pkcs11.ConstructKeys;constructPrivateKey(byte[], String);0" or
  s = "sun.security.pkcs11.ConstructKeys;constructSecretKey(byte[], String);0" or
  s = "sun.security.pkcs11.P11Cipher;engineUnwrap(byte[], String, int);0" or
  s = "sun.security.pkcs11.P11KeyStore;engineSetKeyEntry(String, byte[], Certificate[]);1" or
  s = "sun.security.pkcs11.P11RSACipher;engineUnwrap(byte[], String, int);0" or
  s = "sun.security.pkcs11.P11SecretKeyFactory;fixDESParity(byte[], int);0" or
  s = "sun.security.pkcs12.PKCS12KeyStore;engineSetKeyEntry(String, byte[], Certificate[]);1" or
  s = "sun.security.provider.DomainKeyStore;engineSetKeyEntry(String, byte[], Certificate[]);1" or
  s = "sun.security.provider.JavaKeyStore;engineSetKeyEntry(String, byte[], Certificate[]);1" or
  s = "sun.security.tools.keytool.Main;recoverKey(String, char[], char[]);2" or
  s = "sun.security.tools.keytool.Main;getKeyPasswd(String, String, char[]);2" or
  s = "sun.security.x509.X509Key;decode(byte[]);0"
}

/**
 * Holds if callable `c` from a known API expects a credential parameter at index `i`.
 */
predicate otherApiCallableCredentialParam(Callable c, int i) {
  exists(c.getParameter(i)) and
  otherApiCallableCredentialParam(c.getDeclaringType().getQualifiedName() + ";" +
      c.getStringSignature() + ";" + i)
}

private predicate otherApiCallableCredentialParam(string s) {
  s = "javax.crypto.spec.IvParameterSpec;IvParameterSpec(byte[]);0" or
  s = "javax.crypto.spec.IvParameterSpec;IvParameterSpec(byte[], int, int);0" or
  s =
    "org.springframework.security.core.userdetails.User;User(String, String, boolean, boolean, boolean, boolean, Collection<? extends GrantedAuthority>);0" or
  s =
    "org.springframework.security.core.userdetails.User;User(String, String, boolean, boolean, boolean, boolean, Collection<? extends GrantedAuthority>);1"
}
