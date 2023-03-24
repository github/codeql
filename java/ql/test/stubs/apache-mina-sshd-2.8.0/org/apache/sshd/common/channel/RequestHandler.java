// Generated automatically from org.apache.sshd.common.channel.RequestHandler for testing purposes

package org.apache.sshd.common.channel;

import java.util.Set;
import org.apache.sshd.common.util.buffer.Buffer;

public interface RequestHandler<T>
{
    RequestHandler.Result process(T p0, String p1, boolean p2, Buffer p3);
    static public enum Result
    {
        Replied, ReplyFailure, ReplySuccess, Unsupported;
        private Result() {}
        public static RequestHandler.Result fromName(String p0){ return null; }
        public static Set<RequestHandler.Result> VALUES = null;
    }
}
