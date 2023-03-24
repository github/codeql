// Generated automatically from org.apache.sshd.common.session.helpers.AbstractSession for testing purposes

package org.apache.sshd.common.session.helpers;

import java.time.Duration;
import java.time.Instant;
import java.util.AbstractMap;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.AtomicReference;
import org.apache.sshd.common.Closeable;
import org.apache.sshd.common.FactoryManager;
import org.apache.sshd.common.Service;
import org.apache.sshd.common.channel.ChannelListener;
import org.apache.sshd.common.cipher.Cipher;
import org.apache.sshd.common.cipher.CipherInformation;
import org.apache.sshd.common.compression.Compression;
import org.apache.sshd.common.compression.CompressionInformation;
import org.apache.sshd.common.forward.PortForwardingEventListener;
import org.apache.sshd.common.future.DefaultKeyExchangeFuture;
import org.apache.sshd.common.future.KeyExchangeFuture;
import org.apache.sshd.common.io.IoSession;
import org.apache.sshd.common.io.IoWriteFuture;
import org.apache.sshd.common.kex.KexProposalOption;
import org.apache.sshd.common.kex.KexState;
import org.apache.sshd.common.kex.KeyExchange;
import org.apache.sshd.common.mac.Mac;
import org.apache.sshd.common.mac.MacInformation;
import org.apache.sshd.common.random.Random;
import org.apache.sshd.common.session.SessionListener;
import org.apache.sshd.common.session.SessionWorkBuffer;
import org.apache.sshd.common.session.helpers.PendingWriteFuture;
import org.apache.sshd.common.session.helpers.SessionHelper;
import org.apache.sshd.common.util.Readable;
import org.apache.sshd.common.util.buffer.Buffer;

abstract public class AbstractSession extends SessionHelper
{
    protected AbstractSession() {}
    protected <B extends Buffer> B validateTargetBuffer(int p0, B p1){ return null; }
    protected AbstractSession(boolean p0, FactoryManager p1, IoSession p2){}
    protected AbstractSession.MessageCodingSettings inSettings = null;
    protected AbstractSession.MessageCodingSettings outSettings = null;
    protected Boolean firstKexPacketFollows = null;
    protected Buffer encode(Buffer p0){ return null; }
    protected Buffer preProcessEncodeBuffer(int p0, Buffer p1){ return null; }
    protected Buffer resolveOutputPacket(Buffer p0){ return null; }
    protected Cipher inCipher = null;
    protected Cipher outCipher = null;
    protected Closeable getInnerCloseable(){ return null; }
    protected Compression inCompression = null;
    protected Compression outCompression = null;
    protected DefaultKeyExchangeFuture kexInitializedFuture = null;
    protected Duration maxRekeyInterval = null;
    protected IoWriteFuture doWritePacket(Buffer p0){ return null; }
    protected IoWriteFuture notImplemented(int p0, Buffer p1){ return null; }
    protected IoWriteFuture sendNewKeys(){ return null; }
    protected KeyExchange kex = null;
    protected KeyExchangeFuture checkRekey(){ return null; }
    protected KeyExchangeFuture requestNewKeysExchange(){ return null; }
    protected List<AbstractMap.SimpleImmutableEntry<PendingWriteFuture, IoWriteFuture>> sendPendingPackets(Queue<PendingWriteFuture> p0){ return null; }
    protected List<Service> getServices(){ return null; }
    protected Mac inMac = null;
    protected Mac outMac = null;
    protected Map.Entry<String, String> comparePreferredKexProposalOption(KexProposalOption p0){ return null; }
    protected Map<KexProposalOption, String> negotiate(){ return null; }
    protected Map<KexProposalOption, String> setNegotiationResult(Map<KexProposalOption, String> p0){ return null; }
    protected PendingWriteFuture enqueuePendingPacket(Buffer p0){ return null; }
    protected Service currentService = null;
    protected SessionWorkBuffer uncompressBuffer = null;
    protected String clientVersion = null;
    protected String resolveAvailableSignaturesProposal(){ return null; }
    protected String resolveSessionKexProposal(String p0){ return null; }
    protected String serverVersion = null;
    protected abstract String resolveAvailableSignaturesProposal(FactoryManager p0);
    protected abstract boolean readIdentification(Buffer p0);
    protected abstract void checkKeys();
    protected abstract void receiveKexInit(Map<KexProposalOption, String> p0, byte[] p1);
    protected abstract void setKexSeed(byte... p0);
    protected boolean doInvokeUnimplementedMessageHandler(int p0, Buffer p1){ return false; }
    protected boolean handleFirstKexPacketFollows(int p0, Buffer p1, boolean p2){ return false; }
    protected boolean handleServiceRequest(String p0, Buffer p1){ return false; }
    protected boolean isRekeyBlocksCountExceeded(){ return false; }
    protected boolean isRekeyDataSizeExceeded(){ return false; }
    protected boolean isRekeyPacketCountsExceeded(){ return false; }
    protected boolean isRekeyRequired(){ return false; }
    protected boolean isRekeyTimeIntervalExceeded(){ return false; }
    protected byte[] getClientKexData(){ return null; }
    protected byte[] getServerKexData(){ return null; }
    protected byte[] inMacResult = null;
    protected byte[] receiveKexInit(Buffer p0){ return null; }
    protected byte[] receiveKexInit(Buffer p0, Map<KexProposalOption, String> p1){ return null; }
    protected byte[] sendKexInit(){ return null; }
    protected byte[] sendKexInit(Map<KexProposalOption, String> p0){ return null; }
    protected byte[] sessionId = null;
    protected final AtomicLong globalRequestSeqo = null;
    protected final AtomicLong ignorePacketsCount = null;
    protected final AtomicLong inBlocksCount = null;
    protected final AtomicLong inBytesCount = null;
    protected final AtomicLong inPacketsCount = null;
    protected final AtomicLong maxRekeyBlocks = null;
    protected final AtomicLong outBlocksCount = null;
    protected final AtomicLong outBytesCount = null;
    protected final AtomicLong outPacketsCount = null;
    protected final AtomicReference<DefaultKeyExchangeFuture> kexFutureHolder = null;
    protected final AtomicReference<Instant> lastKeyTimeValue = null;
    protected final AtomicReference<KexState> kexState = null;
    protected final AtomicReference<String> pendingGlobalRequest = null;
    protected final ChannelListener channelListenerProxy = null;
    protected final Collection<ChannelListener> channelListeners = null;
    protected final Collection<PortForwardingEventListener> tunnelListeners = null;
    protected final Collection<SessionListener> sessionListeners = null;
    protected final Map<KexProposalOption, String> clientProposal = null;
    protected final Map<KexProposalOption, String> negotiationResult = null;
    protected final Map<KexProposalOption, String> serverProposal = null;
    protected final Map<KexProposalOption, String> unmodClientProposal = null;
    protected final Map<KexProposalOption, String> unmodNegotiationResult = null;
    protected final Map<KexProposalOption, String> unmodServerProposal = null;
    protected final Object decodeLock = null;
    protected final Object encodeLock = null;
    protected final Object kexLock = null;
    protected final Object requestLock = null;
    protected final PortForwardingEventListener tunnelListenerProxy = null;
    protected final Queue<PendingWriteFuture> pendingPackets = null;
    protected final Random random = null;
    protected final SessionListener sessionListenerProxy = null;
    protected final SessionWorkBuffer decoderBuffer = null;
    protected int decoderLength = 0;
    protected int decoderState = 0;
    protected int ignorePacketDataLength = 0;
    protected int ignorePacketsVariance = 0;
    protected int inCipherSize = 0;
    protected int inMacSize = 0;
    protected int outCipherSize = 0;
    protected int outMacSize = 0;
    protected int resolveIgnoreBufferDataLength(){ return 0; }
    protected long determineRekeyBlockLimit(int p0, int p1){ return 0; }
    protected long ignorePacketsFrequency = 0;
    protected long maxRekeyBytes = 0;
    protected long maxRekyPackets = 0;
    protected long seqi = 0;
    protected long seqo = 0;
    protected void aeadOutgoingBuffer(Buffer p0, int p1, int p2){}
    protected void appendOutgoingMac(Buffer p0, int p1, int p2){}
    protected void decode(){}
    protected void doHandleMessage(Buffer p0){}
    protected void doKexNegotiation(){}
    protected void encryptOutgoingBuffer(Buffer p0, int p1, int p2){}
    protected void handleKexExtension(int p0, Buffer p1){}
    protected void handleKexInit(Buffer p0){}
    protected void handleKexMessage(int p0, Buffer p1){}
    protected void handleMessage(Buffer p0){}
    protected void handleNewCompression(int p0, Buffer p1){}
    protected void handleNewKeys(int p0, Buffer p1){}
    protected void handleServiceAccept(Buffer p0){}
    protected void handleServiceAccept(String p0, Buffer p1){}
    protected void handleServiceRequest(Buffer p0){}
    protected void preClose(){}
    protected void prepareNewKeys(){}
    protected void refreshConfiguration(){}
    protected void requestFailure(Buffer p0){}
    protected void requestSuccess(Buffer p0){}
    protected void setClientKexData(byte[] p0){}
    protected void setInputEncoding(){}
    protected void setOutputEncoding(){}
    protected void setServerKexData(byte[] p0){}
    protected void signalRequestFailure(){}
    protected void validateIncomingMac(byte[] p0, int p1, int p2){}
    protected void validateKexState(int p0, KexState p1){}
    public <T extends Service> T getService(Class<T> p0){ return null; }
    public Buffer createBuffer(byte p0, int p1){ return null; }
    public Buffer prepareBuffer(byte p0, Buffer p1){ return null; }
    public Buffer request(String p0, Buffer p1, long p2){ return null; }
    public ChannelListener getChannelListenerProxy(){ return null; }
    public CipherInformation getCipherInformation(boolean p0){ return null; }
    public CompressionInformation getCompressionInformation(boolean p0){ return null; }
    public IoWriteFuture writePacket(Buffer p0){ return null; }
    public KexState getKexState(){ return null; }
    public KeyExchange getKex(){ return null; }
    public KeyExchangeFuture reExchangeKeys(){ return null; }
    public MacInformation getMacInformation(boolean p0){ return null; }
    public Map<KexProposalOption, String> getClientKexProposals(){ return null; }
    public Map<KexProposalOption, String> getKexNegotiationResult(){ return null; }
    public Map<KexProposalOption, String> getServerKexProposals(){ return null; }
    public PortForwardingEventListener getPortForwardingEventListenerProxy(){ return null; }
    public SessionListener getSessionListenerProxy(){ return null; }
    public String getClientVersion(){ return null; }
    public String getNegotiatedKexParameter(KexProposalOption p0){ return null; }
    public String getServerVersion(){ return null; }
    public byte[] getSessionId(){ return null; }
    public static AbstractSession getSession(IoSession p0){ return null; }
    public static AbstractSession getSession(IoSession p0, boolean p1){ return null; }
    public static String SESSION = null;
    public static int calculatePadLength(int p0, int p1, boolean p2){ return 0; }
    public static void attachSession(IoSession p0, AbstractSession p1){}
    public void addChannelListener(ChannelListener p0){}
    public void addPortForwardingEventListener(PortForwardingEventListener p0){}
    public void addSessionListener(SessionListener p0){}
    public void messageReceived(Readable p0){}
    public void removeChannelListener(ChannelListener p0){}
    public void removePortForwardingEventListener(PortForwardingEventListener p0){}
    public void removeSessionListener(SessionListener p0){}
    static class MessageCodingSettings
    {
        protected MessageCodingSettings() {}
        public Cipher getCipher(long p0){ return null; }
        public Compression getCompression(){ return null; }
        public Mac getMac(){ return null; }
        public MessageCodingSettings(Cipher p0, Mac p1, Compression p2, Cipher.Mode p3, byte[] p4, byte[] p5){}
    }
}
