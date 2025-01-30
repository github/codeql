#include <windows.h>
#include <ntsecapi.h>
#include <stdio.h>
#include <sspi.h>
#include <schnlsp.h>

void UseOfDeprecatedSecurityProtocolGood()
{

    SCHANNEL_CRED credData;
    ZeroMemory(&credData, sizeof(credData));

    // BAD: Deprecated protocols
    credData.grbitEnabledProtocols = SP_PROT_PCT1_SERVER;
    credData.grbitEnabledProtocols = SP_PROT_SSL2_SERVER;
    credData.grbitEnabledProtocols = SP_PROT_SSL3_SERVER;
    credData.grbitEnabledProtocols = SP_PROT_TLS1_1;
    credData.grbitEnabledProtocols = SP_PROT_TLS1_1_SERVER;
    credData.grbitEnabledProtocols = SP_PROT_TLS1_1_CLIENT;
    credData.grbitEnabledProtocols = SP_PROT_SSL3TLS1;

    return;
}