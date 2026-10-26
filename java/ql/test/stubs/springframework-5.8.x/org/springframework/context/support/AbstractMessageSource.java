// Generated automatically from org.springframework.context.support.AbstractMessageSource for testing purposes

package org.springframework.context.support;

import java.text.MessageFormat;
import java.util.Locale;
import java.util.Properties;
import org.springframework.context.HierarchicalMessageSource;
import org.springframework.context.MessageSource;
import org.springframework.context.MessageSourceResolvable;
import org.springframework.context.support.MessageSourceSupport;

abstract public class AbstractMessageSource extends MessageSourceSupport implements HierarchicalMessageSource
{
    protected Object[] resolveArguments(Object[] p0, Locale p1){ return null; }
    protected Properties getCommonMessages(){ return null; }
    protected String getDefaultMessage(MessageSourceResolvable p0, Locale p1){ return null; }
    protected String getDefaultMessage(String p0){ return null; }
    protected String getMessageFromParent(String p0, Object[] p1, Locale p2){ return null; }
    protected String getMessageInternal(String p0, Object[] p1, Locale p2){ return null; }
    protected String resolveCodeWithoutArguments(String p0, Locale p1){ return null; }
    protected abstract MessageFormat resolveCode(String p0, Locale p1);
    protected boolean isUseCodeAsDefaultMessage(){ return false; }
    public AbstractMessageSource(){}
    public MessageSource getParentMessageSource(){ return null; }
    public final String getMessage(MessageSourceResolvable p0, Locale p1){ return null; }
    public final String getMessage(String p0, Object[] p1, Locale p2){ return null; }
    public final String getMessage(String p0, Object[] p1, String p2, Locale p3){ return null; }
    public void setCommonMessages(Properties p0){}
    public void setParentMessageSource(MessageSource p0){}
    public void setUseCodeAsDefaultMessage(boolean p0){}
}
