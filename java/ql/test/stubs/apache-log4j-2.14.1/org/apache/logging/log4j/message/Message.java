// Generated automatically from org.apache.logging.log4j.message.Message for testing purposes

package org.apache.logging.log4j.message;

import java.io.Serializable;

public interface Message extends Serializable
{
    Object[] getParameters();
    String getFormat();
    String getFormattedMessage();
    Throwable getThrowable();
}
