// Generated automatically from org.apache.sshd.common.kex.AbstractKexFactoryManager for testing purposes

package org.apache.sshd.common.kex;

import java.util.Collection;
import java.util.List;
import org.apache.sshd.common.NamedFactory;
import org.apache.sshd.common.cipher.Cipher;
import org.apache.sshd.common.compression.Compression;
import org.apache.sshd.common.kex.KexFactoryManager;
import org.apache.sshd.common.kex.KeyExchangeFactory;
import org.apache.sshd.common.kex.extension.KexExtensionHandler;
import org.apache.sshd.common.mac.Mac;
import org.apache.sshd.common.signature.Signature;
import org.apache.sshd.common.util.closeable.AbstractInnerCloseable;

abstract public class AbstractKexFactoryManager extends AbstractInnerCloseable implements KexFactoryManager
{
    protected <V, C extends Collection<V>> C resolveEffectiveFactories(C p0, C p1){ return null; }
    protected <V> V resolveEffectiveProvider(Class<V> p0, V p1, V p2){ return null; }
    protected AbstractKexFactoryManager(){}
    protected AbstractKexFactoryManager(KexFactoryManager p0){}
    protected KexFactoryManager getDelegate(){ return null; }
    public KexExtensionHandler getKexExtensionHandler(){ return null; }
    public List<KeyExchangeFactory> getKeyExchangeFactories(){ return null; }
    public List<NamedFactory<Cipher>> getCipherFactories(){ return null; }
    public List<NamedFactory<Compression>> getCompressionFactories(){ return null; }
    public List<NamedFactory<Mac>> getMacFactories(){ return null; }
    public List<NamedFactory<Signature>> getSignatureFactories(){ return null; }
    public void setCipherFactories(List<NamedFactory<Cipher>> p0){}
    public void setCompressionFactories(List<NamedFactory<Compression>> p0){}
    public void setKexExtensionHandler(KexExtensionHandler p0){}
    public void setKeyExchangeFactories(List<KeyExchangeFactory> p0){}
    public void setMacFactories(List<NamedFactory<Mac>> p0){}
    public void setSignatureFactories(List<NamedFactory<Signature>> p0){}
}
