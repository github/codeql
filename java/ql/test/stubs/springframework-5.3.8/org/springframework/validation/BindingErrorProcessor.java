// Generated automatically from org.springframework.validation.BindingErrorProcessor for testing purposes

package org.springframework.validation;

import org.springframework.beans.PropertyAccessException;
import org.springframework.validation.BindingResult;

public interface BindingErrorProcessor
{
    void processMissingFieldError(String p0, BindingResult p1);
    void processPropertyAccessException(PropertyAccessException p0, BindingResult p1);
}
