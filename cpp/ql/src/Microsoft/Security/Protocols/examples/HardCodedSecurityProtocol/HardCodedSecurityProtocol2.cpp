#include <windows.h>
#include <ntsecapi.h>
#include <stdio.h>
#include <sspi.h>
#include <schnlsp.h>

void HardCodedSecurityProtocolGood()
{

    SCHANNEL_CRED credData;
    ZeroMemory(&credData, sizeof(credData));

    // GOOD: system default protocol
    credData.grbitEnabledProtocols = 0;

    return;
}