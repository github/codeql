// Generated automatically from org.springframework.validation.AbstractBindingResult for testing purposes

package org.springframework.validation;

import java.beans.PropertyEditor;
import java.io.Serializable;
import java.util.List;
import java.util.Map;
import org.springframework.beans.PropertyEditorRegistry;
import org.springframework.validation.AbstractErrors;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Errors;
import org.springframework.validation.FieldError;
import org.springframework.validation.MessageCodesResolver;
import org.springframework.validation.ObjectError;

abstract public class AbstractBindingResult extends AbstractErrors implements BindingResult, Serializable
{
    protected AbstractBindingResult() {}
    protected AbstractBindingResult(String p0){}
    protected Object formatFieldValue(String p0, Object p1){ return null; }
    protected abstract Object getActualFieldValue(String p0);
    public Class<? extends Object> getFieldType(String p0){ return null; }
    public FieldError getFieldError(){ return null; }
    public FieldError getFieldError(String p0){ return null; }
    public List<FieldError> getFieldErrors(){ return null; }
    public List<FieldError> getFieldErrors(String p0){ return null; }
    public List<ObjectError> getAllErrors(){ return null; }
    public List<ObjectError> getGlobalErrors(){ return null; }
    public Map<String, Object> getModel(){ return null; }
    public MessageCodesResolver getMessageCodesResolver(){ return null; }
    public Object getFieldValue(String p0){ return null; }
    public Object getRawFieldValue(String p0){ return null; }
    public ObjectError getGlobalError(){ return null; }
    public PropertyEditor findEditor(String p0, Class<? extends Object> p1){ return null; }
    public PropertyEditorRegistry getPropertyEditorRegistry(){ return null; }
    public String getObjectName(){ return null; }
    public String[] getSuppressedFields(){ return null; }
    public String[] resolveMessageCodes(String p0){ return null; }
    public String[] resolveMessageCodes(String p0, String p1){ return null; }
    public abstract Object getTarget();
    public boolean equals(Object p0){ return false; }
    public boolean hasErrors(){ return false; }
    public int getErrorCount(){ return 0; }
    public int hashCode(){ return 0; }
    public void addAllErrors(Errors p0){}
    public void addError(ObjectError p0){}
    public void recordFieldValue(String p0, Class<? extends Object> p1, Object p2){}
    public void recordSuppressedField(String p0){}
    public void reject(String p0, Object[] p1, String p2){}
    public void rejectValue(String p0, String p1, Object[] p2, String p3){}
    public void setMessageCodesResolver(MessageCodesResolver p0){}
}
