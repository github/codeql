// Generated automatically from org.springframework.context.HierarchicalMessageSource for testing purposes

package org.springframework.context;

import org.springframework.context.MessageSource;

public interface HierarchicalMessageSource extends MessageSource
{
    MessageSource getParentMessageSource();
    void setParentMessageSource(MessageSource p0);
}
