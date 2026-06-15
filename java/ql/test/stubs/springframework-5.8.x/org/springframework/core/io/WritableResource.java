// Generated automatically from org.springframework.core.io.WritableResource for testing purposes

package org.springframework.core.io;

import java.io.OutputStream;
import java.nio.channels.WritableByteChannel;
import org.springframework.core.io.Resource;

public interface WritableResource extends Resource
{
    OutputStream getOutputStream();
    default WritableByteChannel writableChannel(){ return null; }
    default boolean isWritable(){ return false; }
}
