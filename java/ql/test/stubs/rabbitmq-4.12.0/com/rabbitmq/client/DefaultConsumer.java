package com.rabbitmq.client;

import java.io.IOException;

public class DefaultConsumer implements Consumer {

    public DefaultConsumer(Channel channel) {

    }

    @Override
    public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties, byte[] body)
            throws IOException {
    }
}
