// Generated automatically from io.netty.channel.ChannelId for testing purposes

package io.netty.channel;

import java.io.Serializable;

public interface ChannelId extends Comparable<ChannelId>, Serializable
{
    String asLongText();
    String asShortText();
}
