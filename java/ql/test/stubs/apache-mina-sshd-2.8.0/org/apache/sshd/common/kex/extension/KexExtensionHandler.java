// Generated automatically from org.apache.sshd.common.kex.extension.KexExtensionHandler for testing purposes

package org.apache.sshd.common.kex.extension;

import java.util.Map;
import java.util.Set;
import org.apache.sshd.common.kex.KexProposalOption;
import org.apache.sshd.common.session.Session;
import org.apache.sshd.common.util.buffer.Buffer;

public interface KexExtensionHandler
{
    default boolean handleKexCompressionMessage(Session p0, Buffer p1){ return false; }
    default boolean handleKexExtensionRequest(Session p0, int p1, int p2, String p3, byte[] p4){ return false; }
    default boolean handleKexExtensionsMessage(Session p0, Buffer p1){ return false; }
    default boolean isKexExtensionsAvailable(Session p0, KexExtensionHandler.AvailabilityPhase p1){ return false; }
    default void handleKexExtensionNegotiation(Session p0, KexProposalOption p1, String p2, Map<KexProposalOption, String> p3, String p4, Map<KexProposalOption, String> p5, String p6){}
    default void handleKexInitProposal(Session p0, boolean p1, Map<KexProposalOption, String> p2){}
    default void sendKexExtensions(Session p0, KexExtensionHandler.KexPhase p1){}
    static public enum AvailabilityPhase
    {
        AUTHOK, NEWKEYS, PREKEX, PROPOSAL;
        private AvailabilityPhase() {}
    }
    static public enum KexPhase
    {
        AUTHOK, NEWKEYS;
        private KexPhase() {}
        public static Set<KexExtensionHandler.KexPhase> VALUES = null;
    }
}
