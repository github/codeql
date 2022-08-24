// Generated automatically from org.apache.sshd.common.io.IoOutputStream for testing purposes

package org.apache.sshd.common.io;

import org.apache.sshd.common.Closeable;
import org.apache.sshd.common.io.IoWriteFuture;
import org.apache.sshd.common.util.buffer.Buffer;

public interface IoOutputStream extends Closeable
{
    IoWriteFuture writeBuffer(Buffer p0);
}
