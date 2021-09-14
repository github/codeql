// Generated automatically from org.springframework.validation.BindingResult for testing purposes

package org.springframework.validation;

import java.beans.PropertyEditor;
import java.util.Map;
import org.springframework.beans.PropertyEditorRegistry;
import org.springframework.validation.Errors;
import org.springframework.validation.ObjectError;

public interface BindingResult extends Errors
{
    Map<String, Object> getModel();
    Object getRawFieldValue(String p0);
    Object getTarget();
    PropertyEditor findEditor(String p0, Class<? extends Object> p1);
    PropertyEditorRegistry getPropertyEditorRegistry();
    String[] resolveMessageCodes(String p0);
    String[] resolveMessageCodes(String p0, String p1);
    default String[] getSuppressedFields(){ return null; }
    default void recordFieldValue(String p0, Class<? extends Object> p1, Object p2){}
    default void recordSuppressedField(String p0){}
    static String MODEL_KEY_PREFIX = null;
    void addError(ObjectError p0);
}
