// Generated automatically from org.springframework.validation.AbstractErrors for testing purposes

package org.springframework.validation;

import java.io.Serializable;
import java.util.List;
import org.springframework.validation.Errors;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;

abstract public class AbstractErrors implements Errors, Serializable
{
    protected String canonicalFieldName(String p0){ return null; }
    protected String fixedField(String p0){ return null; }
    protected boolean isMatchingFieldError(String p0, FieldError p1){ return false; }
    protected void doSetNestedPath(String p0){}
    public AbstractErrors(){}
    public Class<? extends Object> getFieldType(String p0){ return null; }
    public FieldError getFieldError(){ return null; }
    public FieldError getFieldError(String p0){ return null; }
    public List<FieldError> getFieldErrors(String p0){ return null; }
    public List<ObjectError> getAllErrors(){ return null; }
    public ObjectError getGlobalError(){ return null; }
    public String getNestedPath(){ return null; }
    public String toString(){ return null; }
    public boolean hasErrors(){ return false; }
    public boolean hasFieldErrors(){ return false; }
    public boolean hasFieldErrors(String p0){ return false; }
    public boolean hasGlobalErrors(){ return false; }
    public int getErrorCount(){ return 0; }
    public int getFieldErrorCount(){ return 0; }
    public int getFieldErrorCount(String p0){ return 0; }
    public int getGlobalErrorCount(){ return 0; }
    public void popNestedPath(){}
    public void pushNestedPath(String p0){}
    public void reject(String p0){}
    public void reject(String p0, String p1){}
    public void rejectValue(String p0, String p1){}
    public void rejectValue(String p0, String p1, String p2){}
    public void setNestedPath(String p0){}
}
