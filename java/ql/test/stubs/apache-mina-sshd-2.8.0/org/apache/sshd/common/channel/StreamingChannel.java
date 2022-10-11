// Generated automatically from org.apache.sshd.common.channel.StreamingChannel for testing purposes

package org.apache.sshd.common.channel;


public interface StreamingChannel
{
    StreamingChannel.Streaming getStreaming();
    static public enum Streaming
    {
        Async, Sync;
        private Streaming() {}
    }
    void setStreaming(StreamingChannel.Streaming p0);
}
