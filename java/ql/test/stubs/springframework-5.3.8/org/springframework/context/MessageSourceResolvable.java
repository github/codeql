// Generated automatically from org.springframework.context.MessageSourceResolvable for testing purposes

package org.springframework.context;


public interface MessageSourceResolvable
{
    String[] getCodes();
    default Object[] getArguments(){ return null; }
    default String getDefaultMessage(){ return null; }
}
