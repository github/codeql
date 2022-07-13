package com.rabbitmq.client;

public class QueueingConsumer extends DefaultConsumer {

    public QueueingConsumer(Channel channel) {
        super(channel);
    }
    
    public Delivery nextDelivery() {
        return null;
    }

    public Delivery nextDelivery(long timeout) {
        return null;
    }

    public static class Delivery {

        public byte[] getBody() {
            return null;
        }
    }
}
