# MaD Generation Report

## Included (14)

| Package | Class | Method | Type | Kind | Certainty | Reason |
|---------|-------|--------|------|------|-----------|--------|
| org.apache.axis2.transport.jms.ctype | PropertyRule | getContentType | source | remote | 4 | The method reads a string property from a JMS Message (via Message.getStringProperty) received from an external message broker. The return value encapsulates content type information extracted from the external message, making it a remote data source. |
| org.apache.axis2.transport.jms.iowrappers | BytesMessageDataSource | getInputStream | source | remote | 4 | Returns an InputStream that reads data from a JMS BytesMessage. JMS messages originate from external message queues (remote systems), so the returned stream carries externally-sourced data that did not exist in the process before the message was received. |
| org.apache.axis2.transport.jms.iowrappers | BytesMessageInputStream | read | source | remote | 4 | Reads bytes from a JMS BytesMessage (via BytesMessage.readBytes) into the byte array parameter (arg 0). JMS messages originate from external message brokers, making this a remote data source. |
| org.apache.axis2.transport.jms.iowrappers | BytesMessageInputStream | read | source | remote | 4 | Reads bytes from a JMS BytesMessage (via BytesMessage.readBytes) into the byte array parameter (arg 0). JMS messages originate from external message brokers, making this a remote data source. |
| org.apache.axis2.transport.jms | JMSConnectionFactory | getDestination | sink | CWE-074 | 4 | Argument 0 (destinationName) is used as a JNDI lookup name via JMSUtils.lookupDestination(Context, String, String). If this name is attacker-controlled, it can point to a malicious JNDI server, potentially leading to remote code execution (JNDI injection). |
| org.apache.axis2.transport.jms | JMSConnectionFactoryManager | handleException | sink | CWE-117 | 4 | Argument 0 (msg) is passed directly to Log.error(), which writes it to the log. If msg contains unsanitized user input, this enables log injection (e.g., forged log entries via newline characters). |
| org.apache.axis2.transport.jms | JMSMessageReceiver | onMessage | source | remote | 4 | The Message parameter (arg 0) is data received from an external JMS message queue. This method is a well-known JMS framework callback invoked when a message arrives. The callees confirm it reads message content (getText, getJMSMessageID, getJMSCorrelationID, etc.) and processes it through the engine, making this the entry point where external data enters the application. |
| org.apache.axis2.transport.jms | JMSMessageSender | JMSMessageSender | sink | CWE-918 | 4 | Argument 1 (targetAddress) is a target EPR (endpoint reference) used to resolve the JMS destination. Callees show it flows into JMSUtils.getDestination(String) and JMSConnectionFactory.getDestination(String,String), setting up a server-side connection to a potentially attacker-controlled destination, enabling request forgery. |
| org.apache.axis2.transport.jms | JMSOutTransportInfo | getReplyDestination | sink | CWE-074 | 5 | Argument 0 (replyDest) is used as a JNDI name in a lookup via JMSUtils.lookupDestination(). If this name is attacker-controlled, it can point to a malicious LDAP/RMI server and lead to remote code execution through JNDI injection. |
| org.apache.axis2.transport.jms | JMSSender | sendMessage | sink | CWE-918 | 4 | Argument 1 (targetAddress) specifies the JMS endpoint/broker address where the message is sent. If attacker-controlled, the server could be made to connect to an arbitrary JMS broker, enabling SSRF. Callees confirm the address is used to create JMSOutTransportInfo and send the message via sendOverJMS. |
| org.apache.axis2.transport.jms | JMSUtils | getProperty | source | remote | 5 | The return value is a string property read from a JMS Message, which originates from an external/remote messaging system. Callees confirm delegation to jakarta.jms.Message.getStringProperty(). |
| org.apache.axis2.transport.jms | JMSUtils | getTransportHeaders | source | remote | 5 | The return value is a Map containing transport headers extracted from a JMS Message. Callees confirm it reads multiple properties (getStringProperty, getJMSCorrelationID, getJMSMessageID, getJMSType, etc.) from the external message. |
| org.apache.axis2.transport.jms | JMSUtils | lookup | sink | CWE-074 | 5 | Argument 2 (name) is used in a JNDI lookup via javax.naming.Context.lookup(String). If attacker-controlled, this can lead to JNDI injection allowing remote code execution. |
| org.apache.axis2.transport.jms | JMSUtils | lookupDestination | sink | CWE-074 | 5 | Argument 1 (destinationName) is passed to JMSUtils.lookup() which performs a JNDI lookup via javax.naming.Context.lookup(String). If attacker-controlled, this can lead to JNDI injection. |

## Ignored (low certainty) (0)

None.

