// Generated automatically from org.apache.sshd.common.kex.KexProposalOption for testing purposes

package org.apache.sshd.common.kex;

import java.util.Comparator;
import java.util.List;
import java.util.Set;

public enum KexProposalOption
{
    ALGORITHMS, C2SCOMP, C2SENC, C2SLANG, C2SMAC, S2CCOMP, S2CENC, S2CLANG, S2CMAC, SERVERKEYS;
    private KexProposalOption() {}
    public final String getDescription(){ return null; }
    public final int getProposalIndex(){ return 0; }
    public static Comparator<KexProposalOption> BY_PROPOSAL_INDEX = null;
    public static KexProposalOption fromName(String p0){ return null; }
    public static KexProposalOption fromProposalIndex(int p0){ return null; }
    public static List<KexProposalOption> VALUES = null;
    public static Set<KexProposalOption> CIPHER_PROPOSALS = null;
    public static Set<KexProposalOption> COMPRESSION_PROPOSALS = null;
    public static Set<KexProposalOption> FIRST_KEX_PACKET_GUESS_MATCHES = null;
    public static Set<KexProposalOption> LANGUAGE_PROPOSALS = null;
    public static Set<KexProposalOption> MAC_PROPOSALS = null;
    public static int PROPOSAL_MAX = 0;
}
