/**
 * Provides classes and predicates related to RabbitMQ.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow

/**
 * Defines remote sources in RabbitMQ.
 */
private class RabbitMQSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        // soruces for RabbitMQ 4.x
        "com.rabbitmq.client;Command;true;getContentHeader;();;ReturnValue;remote",
        "com.rabbitmq.client;Command;true;getContentBody;();;ReturnValue;remote",
        "com.rabbitmq.client;Consumer;true;handleDelivery;(String,Envelope,BasicProperties,byte[]);;Parameter[3];remote",
        "com.rabbitmq.client;QueueingConsumer;true;nextDelivery;;;ReturnValue;remote",
        "com.rabbitmq.client;RpcServer;true;handleCall;(Delivery,BasicProperties);;Parameter[0];remote",
        "com.rabbitmq.client;RpcServer;true;handleCall;(BasicProperties,byte[],BasicProperties);;Parameter[1];remote",
        "com.rabbitmq.client;RpcServer;true;handleCall;(byte[],BasicProperties);;Parameter[0];remote",
        "com.rabbitmq.client;RpcServer;true;preprocessReplyProperties;(Delivery,Builder);;Parameter[0];remote",
        "com.rabbitmq.client;RpcServer;true;postprocessReplyProperties;(Delivery,Builder);;Parameter[0];remote",
        "com.rabbitmq.client;RpcServer;true;handleCast;(Delivery);;Parameter[0];remote",
        "com.rabbitmq.client;RpcServer;true;handleCast;(BasicProperties,byte[]);;Parameter[1];remote",
        "com.rabbitmq.client;RpcServer;true;handleCast;(byte[]);;Parameter[0];remote",
        "com.rabbitmq.client;StringRpcServer;true;handleStringCall;;;Parameter[0];remote",
        "com.rabbitmq.client;RpcClient;true;doCall;;;ReturnValue;remote",
        "com.rabbitmq.client;RpcClient;true;primitiveCall;;;ReturnValue;remote",
        "com.rabbitmq.client;RpcClient;true;responseCall;;;ReturnValue;remote",
        "com.rabbitmq.client;RpcClient;true;stringCall;(String);;ReturnValue;remote",
        "com.rabbitmq.client;RpcClient;true;mapCall;;;ReturnValue;remote",
        "com.rabbitmq.client.impl;Frame;true;getInputStream;();;ReturnValue;remote",
        "com.rabbitmq.client.impl;Frame;true;getPayload;();;ReturnValue;remote",
        "com.rabbitmq.client.impl;FrameHandler;true;readFrame;();;ReturnValue;remote",
      ]
  }
}

/**
 * Defines flow steps in RabbitMQ.
 */
private class RabbitMQSummaryCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        // flow steps for RabbitMQ 4.x
        "com.rabbitmq.client;GetResponse;true;GetResponse;;;Argument[2];Argument[-1];taint",
        "com.rabbitmq.client;GetResponse;true;getBody;();;Argument[-1];ReturnValue;taint",
        "com.rabbitmq.client;RpcClient$Response;true;getBody;();;Argument[-1];ReturnValue;taint",
        "com.rabbitmq.client;QueueingConsumer$Delivery;true;getBody;();;Argument[-1];ReturnValue;taint",
        "com.rabbitmq.client.impl;Frame;false;fromBodyFragment;(int,byte[],int,int);;Argument[1];ReturnValue;taint",
        "com.rabbitmq.client.impl;Frame;false;readFrom;(DataInputStream);;Argument[0];ReturnValue;taint",
        "com.rabbitmq.client.impl;Frame;true;writeTo;(DataOutputStream);;Argument[-1];Argument[0];taint",
      ]
  }
}
