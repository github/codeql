// Generated automatically from org.apache.sshd.common.kex.KexFactoryManager for testing purposes

package org.apache.sshd.common.kex;

import java.util.Collection;
import java.util.List;
import org.apache.sshd.common.NamedFactory;
import org.apache.sshd.common.cipher.Cipher;
import org.apache.sshd.common.compression.Compression;
import org.apache.sshd.common.kex.KeyExchangeFactory;
import org.apache.sshd.common.kex.extension.KexExtensionHandlerManager;
import org.apache.sshd.common.mac.Mac;
import org.apache.sshd.common.signature.SignatureFactoriesManager;

public interface KexFactoryManager extends KexExtensionHandlerManager, SignatureFactoriesManager
{
    List<KeyExchangeFactory> getKeyExchangeFactories();
    List<NamedFactory<Cipher>> getCipherFactories();
    List<NamedFactory<Compression>> getCompressionFactories();
    List<NamedFactory<Mac>> getMacFactories();
    default List<String> getCipherFactoriesNames(){ return null; }
    default List<String> getCompressionFactoriesNames(){ return null; }
    default List<String> getMacFactoriesNames(){ return null; }
    default String getCipherFactoriesNameList(){ return null; }
    default String getCompressionFactoriesNameList(){ return null; }
    default String getMacFactoriesNameList(){ return null; }
    default void setCipherFactoriesNameList(String p0){}
    default void setCipherFactoriesNames(Collection<String> p0){}
    default void setCipherFactoriesNames(String... p0){}
    default void setCompressionFactoriesNameList(String p0){}
    default void setCompressionFactoriesNames(Collection<String> p0){}
    default void setCompressionFactoriesNames(String... p0){}
    default void setMacFactoriesNameList(String p0){}
    default void setMacFactoriesNames(Collection<String> p0){}
    default void setMacFactoriesNames(String... p0){}
    void setCipherFactories(List<NamedFactory<Cipher>> p0);
    void setCompressionFactories(List<NamedFactory<Compression>> p0);
    void setKeyExchangeFactories(List<KeyExchangeFactory> p0);
    void setMacFactories(List<NamedFactory<Mac>> p0);
}
