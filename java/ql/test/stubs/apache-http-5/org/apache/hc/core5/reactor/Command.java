// Generated automatically from org.apache.hc.core5.reactor.Command for testing purposes

package org.apache.hc.core5.reactor;

import org.apache.hc.core5.concurrent.Cancellable;

public interface Command extends Cancellable
{
    static public enum Priority
    {
        IMMEDIATE, NORMAL;
        private Priority() {}
    }
}
