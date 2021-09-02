// Generated automatically from org.springframework.beans.PropertyEditorRegistry for testing purposes

package org.springframework.beans;

import java.beans.PropertyEditor;

public interface PropertyEditorRegistry
{
    PropertyEditor findCustomEditor(Class<? extends Object> p0, String p1);
    void registerCustomEditor(Class<? extends Object> p0, PropertyEditor p1);
    void registerCustomEditor(Class<? extends Object> p0, String p1, PropertyEditor p2);
}
