/**
 * This model covers JMS API versions 1 and 2.
 *
 * https://docs.oracle.com/javaee/6/api/javax/jms/package-summary.html
 * https://docs.oracle.com/javaee/7/api/javax/jms/package-summary.html
 */

import java
private import semmle.code.java.dataflow.ExternalFlow

/** Defines sources of tainted data in JMS 1. */
private class Jms1Source extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        // incoming messages are considered tainted
        "javax.jms;MessageListener;true;onMessage;(Message);;Parameter[0];remote;manual",
        "javax.jms;MessageConsumer;true;receive;;;ReturnValue;remote;manual",
        "javax.jms;MessageConsumer;true;receiveNoWait;();;ReturnValue;remote;manual",
        "javax.jms;QueueRequestor;true;request;(Message);;ReturnValue;remote;manual",
        "javax.jms;TopicRequestor;true;request;(Message);;ReturnValue;remote;manual",
      ]
  }
}

/** Defines taint propagation steps in JMS 1. */
private class Jms1FlowStep extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        // if a message is tainted, then it returns tainted data
        "javax.jms;Message;true;getBody;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;Message;true;getJMSCorrelationIDAsBytes;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;Message;true;getJMSCorrelationID;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;Message;true;getJMSReplyTo;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;Message;true;getJMSDestination;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;Message;true;getJMSType;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;Message;true;getBooleanProperty;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;Message;true;getByteProperty;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;Message;true;getShortProperty;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;Message;true;getIntProperty;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;Message;true;getLongProperty;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;Message;true;getFloatProperty;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;Message;true;getDoubleProperty;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;Message;true;getStringProperty;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;Message;true;getObjectProperty;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;Message;true;getPropertyNames;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;BytesMessage;true;readBoolean;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;BytesMessage;true;readByte;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;BytesMessage;true;readUnsignedByte;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;BytesMessage;true;readShort;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;BytesMessage;true;readUnsignedShort;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;BytesMessage;true;readChar;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;BytesMessage;true;readInt;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;BytesMessage;true;readLong;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;BytesMessage;true;readFloat;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;BytesMessage;true;readDouble;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;BytesMessage;true;readUTF;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;BytesMessage;true;readBytes;;;Argument[-1];Argument[0];taint;manual",
        "javax.jms;MapMessage;true;getBoolean;(String);;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;MapMessage;true;getByte;(String);;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;MapMessage;true;getShort;(String);;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;MapMessage;true;getChar;(String);;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;MapMessage;true;getInt;(String);;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;MapMessage;true;getLong;(String);;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;MapMessage;true;getFloat;(String);;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;MapMessage;true;getDouble;(String);;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;MapMessage;true;getString;(String);;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;MapMessage;true;getBytes;(String);;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;MapMessage;true;getObject;(String);;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;MapMessage;true;getMapNames;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;ObjectMessage;true;getObject;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;StreamMessage;true;readBoolean;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;StreamMessage;true;readByte;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;StreamMessage;true;readShort;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;StreamMessage;true;readChar;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;StreamMessage;true;readInt;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;StreamMessage;true;readLong;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;StreamMessage;true;readFloat;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;StreamMessage;true;readDouble;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;StreamMessage;true;readString;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;StreamMessage;true;readBytes;(byte[]);;Argument[-1];Argument[0];taint;manual",
        "javax.jms;StreamMessage;true;readObject;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;TextMessage;true;getText;();;Argument[-1];ReturnValue;taint;manual",
        // if a destination is tainted, then it returns tainted data
        "javax.jms;Queue;true;getQueueName;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;Queue;true;toString;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;Topic;true;getTopicName;();;Argument[-1];ReturnValue;taint;manual",
        "javax.jms;Topic;true;toString;();;Argument[-1];ReturnValue;taint;manual",
      ]
  }
}

/** Defines additional sources of tainted data in JMS 2. */
private class Jms2Source extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.jms;JMSConsumer;true;receive;;;ReturnValue;remote;manual",
        "javax.jms;JMSConsumer;true;receiveBody;;;ReturnValue;remote;manual",
        "javax.jms;JMSConsumer;true;receiveNoWait;();;ReturnValue;remote;manual",
        "javax.jms;JMSConsumer;true;receiveBodyNoWait;();;ReturnValue;remote;manual",
      ]
  }
}

/** Defines additional taint propagation steps in JMS 2. */
private class Jms2FlowStep extends SummaryModelCsv {
  override predicate row(string row) {
    row = "javax.jms;Message;true;getBody;();;Argument[-1];ReturnValue;taint;manual"
  }
}
