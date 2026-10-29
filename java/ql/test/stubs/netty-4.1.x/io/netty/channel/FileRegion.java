// Generated automatically from io.netty.channel.FileRegion for testing purposes

package io.netty.channel;

import io.netty.util.ReferenceCounted;
import java.nio.channels.WritableByteChannel;

public interface FileRegion extends ReferenceCounted
{
    FileRegion retain();
    FileRegion retain(int p0);
    FileRegion touch();
    FileRegion touch(Object p0);
    long count();
    long position();
    long transferTo(WritableByteChannel p0, long p1);
    long transfered();
    long transferred();
}
