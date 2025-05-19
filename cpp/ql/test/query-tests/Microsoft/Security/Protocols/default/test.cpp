// semmle-extractor-options: --microsoft

typedef unsigned long DWORD;

typedef struct _SCHANNEL_CRED {
  // Note: Fields removed before/after to avoid needing to include headers for field types
  DWORD           grbitEnabledProtocols;
} SCHANNEL_CRED, *PSCHANNEL_CRED;

#define SP_PROT_PCT1_SERVER             0x00000001
#define SP_PROT_PCT1_CLIENT             0x00000002
#define SP_PROT_PCT1                    (SP_PROT_PCT1_SERVER | SP_PROT_PCT1_CLIENT)

#define SP_PROT_SSL2_SERVER             0x00000004
#define SP_PROT_SSL2_CLIENT             0x00000008
#define SP_PROT_SSL2                    (SP_PROT_SSL2_SERVER | SP_PROT_SSL2_CLIENT)

#define SP_PROT_SSL3_SERVER		0x00000010
#define SP_PROT_SSL3_CLIENT		0x00000020
#define SP_PROT_SSL3			(SP_PROT_SSL3_SERVER | SP_PROT_SSL3_CLIENT)

#define SP_PROT_TLS1_SERVER             0x00000040
#define SP_PROT_TLS1_CLIENT             0x00000080
#define SP_PROT_TLS1                    (SP_PROT_TLS1_SERVER | SP_PROT_TLS1_CLIENT)

#define SP_PROT_TLS1_0_SERVER           SP_PROT_TLS1_SERVER
#define SP_PROT_TLS1_0_CLIENT           SP_PROT_TLS1_CLIENT
#define SP_PROT_TLS1_0                  (SP_PROT_TLS1_0_SERVER | \
                                         SP_PROT_TLS1_0_CLIENT)

#define SP_PROT_TLS1_1_SERVER	0x00000100
#define SP_PROT_TLS1_1_CLIENT	0x00000200
#define SP_PROT_TLS1_1			(SP_PROT_TLS1_1_SERVER | SP_PROT_TLS1_1_CLIENT)

#define SP_PROT_SSL3TLS1_CLIENTS        (SP_PROT_TLS1_CLIENT | SP_PROT_SSL3_CLIENT)
#define SP_PROT_SSL3TLS1_SERVERS        (SP_PROT_TLS1_SERVER | SP_PROT_SSL3_SERVER)
#define SP_PROT_SSL3TLS1                (SP_PROT_SSL3 | SP_PROT_TLS1)

#define SP_PROT_TLS1_2_SERVER	0x00000400
#define SP_PROT_TLS1_2_CLIENT	0x00000800
#define SP_PROT_TLS1_2			(SP_PROT_TLS1_2_SERVER | SP_PROT_TLS1_2_CLIENT)

#define SP_PROT_TLS1_3_SERVER   0x00001000
#define SP_PROT_TLS1_3_CLIENT   0x00002000
#define SP_PROT_TLS1_3          (SP_PROT_TLS1_3_SERVER | SP_PROT_TLS1_3_CLIENT)

void testProtocols(bool isServer, DWORD cred) {
	SCHANNEL_CRED testSChannelCred;
	// BAD: Deprecated protocols
	testSChannelCred.grbitEnabledProtocols = SP_PROT_PCT1_SERVER;
	testSChannelCred.grbitEnabledProtocols = SP_PROT_SSL2_SERVER;
	testSChannelCred.grbitEnabledProtocols = SP_PROT_SSL3_SERVER;
	testSChannelCred.grbitEnabledProtocols = SP_PROT_TLS1_1;
	testSChannelCred.grbitEnabledProtocols = (SP_PROT_TLS1_1_SERVER | SP_PROT_TLS1_1_CLIENT);
	testSChannelCred.grbitEnabledProtocols = SP_PROT_SSL3TLS1;
	testSChannelCred.grbitEnabledProtocols = isServer ? SP_PROT_TLS1_1_SERVER : SP_PROT_TLS1_1_CLIENT;
	// BAD: hardcoded, but not deprecated, protocol
	testSChannelCred.grbitEnabledProtocols = SP_PROT_TLS1_2;
	testSChannelCred.grbitEnabledProtocols = SP_PROT_TLS1_3;
	// GOOD: system default protocol
	testSChannelCred.grbitEnabledProtocols = 0;
	// UNKNOWN: Do not flag SP_PROT_TLS1_1 here
	// We do not know anything about cred, so don't flag it
	testSChannelCred.grbitEnabledProtocols = cred & ~SP_PROT_TLS1_1;
}
