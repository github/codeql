// Generated automatically from org.springframework.context.MessageSource for testing purposes

package org.springframework.context;

import java.util.Locale;
import org.springframework.context.MessageSourceResolvable;

public interface MessageSource
{
    String getMessage(MessageSourceResolvable p0, Locale p1);
    String getMessage(String p0, Object[] p1, Locale p2);
    String getMessage(String p0, Object[] p1, String p2, Locale p3);
}
