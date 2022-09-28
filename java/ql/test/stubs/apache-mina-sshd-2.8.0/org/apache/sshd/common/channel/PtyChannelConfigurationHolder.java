// Generated automatically from org.apache.sshd.common.channel.PtyChannelConfigurationHolder for testing purposes

package org.apache.sshd.common.channel;

import java.util.Map;
import org.apache.sshd.common.channel.PtyMode;

public interface PtyChannelConfigurationHolder
{
    Map<PtyMode, Integer> getPtyModes();
    String getPtyType();
    int getPtyColumns();
    int getPtyHeight();
    int getPtyLines();
    int getPtyWidth();
    static Map<PtyMode, Integer> DEFAULT_PTY_MODES = null;
    static String DUMMY_PTY_TYPE = null;
    static String WINDOWS_PTY_TYPE = null;
    static int DEFAULT_COLUMNS_COUNT = 0;
    static int DEFAULT_HEIGHT = 0;
    static int DEFAULT_ROWS_COUNT = 0;
    static int DEFAULT_WIDTH = 0;
}
