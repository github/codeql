// Generated automatically from org.apache.sshd.common.config.keys.FilePasswordProvider for testing purposes

package org.apache.sshd.common.config.keys;

import java.util.Set;
import org.apache.sshd.common.NamedResource;
import org.apache.sshd.common.session.SessionContext;

public interface FilePasswordProvider
{
    String getPassword(SessionContext p0, NamedResource p1, int p2);
    default FilePasswordProvider.ResourceDecodeResult handleDecodeAttemptResult(SessionContext p0, NamedResource p1, int p2, String p3, Exception p4){ return null; }
    static FilePasswordProvider EMPTY = null;
    static FilePasswordProvider of(String p0){ return null; }
    static public enum ResourceDecodeResult
    {
        IGNORE, RETRY, TERMINATE;
        private ResourceDecodeResult() {}
        public static Set<FilePasswordProvider.ResourceDecodeResult> VALUES = null;
    }
}
