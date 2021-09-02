// Generated automatically from org.springframework.beans.PropertyAccessException for testing purposes

package org.springframework.beans;

import java.beans.PropertyChangeEvent;
import org.springframework.beans.BeansException;

abstract public class PropertyAccessException extends BeansException
{
    protected PropertyAccessException() {}
    public Object getValue(){ return null; }
    public PropertyAccessException(PropertyChangeEvent p0, String p1, Throwable p2){}
    public PropertyAccessException(String p0, Throwable p1){}
    public PropertyChangeEvent getPropertyChangeEvent(){ return null; }
    public String getPropertyName(){ return null; }
    public abstract String getErrorCode();
}
