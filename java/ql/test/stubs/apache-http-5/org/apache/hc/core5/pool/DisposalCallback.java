// Generated automatically from org.apache.hc.core5.pool.DisposalCallback for testing purposes

package org.apache.hc.core5.pool;

import org.apache.hc.core5.io.CloseMode;
import org.apache.hc.core5.io.ModalCloseable;

public interface DisposalCallback<T extends ModalCloseable>
{
    void execute(T p0, CloseMode p1);
}
