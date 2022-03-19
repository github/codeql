package com.rabbitmq.client;

import java.io.IOException;;

public interface Consumer {
    void handleDelivery​(String consumerTag, Envelope envelope, AMQP.BasicProperties properties, byte[] body)
            throws IOException;
}
