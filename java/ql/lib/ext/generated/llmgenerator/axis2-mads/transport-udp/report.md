# MaD Generation Report

## Included (1)

| Package | Class | Method | Type | Kind | Certainty | Reason |
|---------|-------|--------|------|------|-----------|--------|
| org.apache.axis2.transport.udp | UDPSender | sendMessage | sink | CWE-918 | 4 | Argument 1 (`targetEPR`) specifies the target endpoint for a UDP network request. The method directly calls `DatagramSocket.send()`, meaning user-controlled input in `targetEPR` can lead to server-side request forgery. |

## Ignored (low certainty) (0)

None.

