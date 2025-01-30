#include <windows.h>
#include <ntsecapi.h>
#include <stdio.h>
#include <sspi.h>
#include <schnlsp.h>

void HardCodedSecurityProtocolGood()
{

    SCHANNEL_CRED credData;
    ZeroMemory(&credData, sizeof(credData));

    // BAD: hardcoded protocols
    credData.grbitEnabledProtocols = SP_PROT_TLS1_2;
    credData.grbitEnabledProtocols = SP_PROT_TLS1_3;

    return;
}