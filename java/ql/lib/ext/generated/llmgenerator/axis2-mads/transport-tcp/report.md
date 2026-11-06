# MaD Generation Report

## Included (1)

| Package | Class | Method | Type | Kind | Certainty | Reason |
|---------|-------|--------|------|------|-----------|--------|
| org.apache.axis2.transport.tcp | TCPTransportSender | sendMessage | sink | CWE-918 | 5 | Argument 1 (targetEPR) is parsed and used to open a TCP connection via openTCPConnection(String, int). An attacker-controlled endpoint reference could lead to server-side request forgery. |

## Ignored (low certainty) (0)

None.

