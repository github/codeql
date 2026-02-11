// Generated automatically from org.springframework.validation.Errors for testing purposes

package org.springframework.validation;

import java.util.List;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;

public interface Errors
{
    Class<? extends Object> getFieldType(String p0);
    FieldError getFieldError();
    FieldError getFieldError(String p0);
    List<FieldError> getFieldErrors();
    List<FieldError> getFieldErrors(String p0);
    List<ObjectError> getAllErrors();
    List<ObjectError> getGlobalErrors();
    Object getFieldValue(String p0);
    ObjectError getGlobalError();
    String getNestedPath();
    String getObjectName();
    boolean hasErrors();
    boolean hasFieldErrors();
    boolean hasFieldErrors(String p0);
    boolean hasGlobalErrors();
    int getErrorCount();
    int getFieldErrorCount();
    int getFieldErrorCount(String p0);
    int getGlobalErrorCount();
    static String NESTED_PATH_SEPARATOR = null;
    void addAllErrors(Errors p0);
    void popNestedPath();
    void pushNestedPath(String p0);
    void reject(String p0);
    void reject(String p0, Object[] p1, String p2);
    void reject(String p0, String p1);
    void rejectValue(String p0, String p1);
    void rejectValue(String p0, String p1, Object[] p2, String p3);
    void rejectValue(String p0, String p1, String p2);
    void setNestedPath(String p0);
}
