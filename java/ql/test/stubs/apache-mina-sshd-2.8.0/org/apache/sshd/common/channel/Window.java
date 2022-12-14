// Generated automatically from org.apache.sshd.common.channel.Window for testing purposes

package org.apache.sshd.common.channel;

import java.nio.channels.Channel;
import java.time.Duration;
import java.util.function.Predicate;
import org.apache.sshd.common.PropertyResolver;
import org.apache.sshd.common.channel.AbstractChannel;
import org.apache.sshd.common.channel.ChannelHolder;
import org.apache.sshd.common.util.logging.AbstractLoggingBean;

public class Window extends AbstractLoggingBean implements Channel, ChannelHolder
{
    protected Window() {}
    protected void checkInitialized(String p0){}
    protected void updateSize(long p0){}
    protected void waitForCondition(Predicate<? super Window> p0, Duration p1){}
    public AbstractChannel getChannel(){ return null; }
    public String toString(){ return null; }
    public Window(AbstractChannel p0, Object p1, boolean p2, boolean p3){}
    public boolean isOpen(){ return false; }
    public long getMaxSize(){ return 0; }
    public long getPacketSize(){ return 0; }
    public long getSize(){ return 0; }
    public long waitForSpace(Duration p0){ return 0; }
    public long waitForSpace(long p0){ return 0; }
    public static Predicate<Window> SPACE_AVAILABLE_PREDICATE = null;
    public void check(long p0){}
    public void close(){}
    public void consume(long p0){}
    public void consumeAndCheck(long p0){}
    public void expand(int p0){}
    public void init(PropertyResolver p0){}
    public void init(long p0, long p1, PropertyResolver p2){}
    public void waitAndConsume(long p0, Duration p1){}
    public void waitAndConsume(long p0, long p1){}
}
