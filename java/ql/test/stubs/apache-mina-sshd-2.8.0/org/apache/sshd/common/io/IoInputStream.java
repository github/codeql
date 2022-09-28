// Generated automatically from org.apache.sshd.common.io.IoInputStream for testing purposes

package org.apache.sshd.common.io;

import org.apache.sshd.common.Closeable;
import org.apache.sshd.common.io.IoReadFuture;
import org.apache.sshd.common.util.buffer.Buffer;

public interface IoInputStream extends Closeable
{
    IoReadFuture read(Buffer p0);
}
