// Generated automatically from org.springframework.beans.PropertyEditorRegistrySupport for testing purposes

package org.springframework.beans;

import java.beans.PropertyEditor;
import org.springframework.beans.PropertyEditorRegistry;
import org.springframework.core.convert.ConversionService;

public class PropertyEditorRegistrySupport implements PropertyEditorRegistry
{
    protected Class<? extends Object> getPropertyType(String p0){ return null; }
    protected Class<? extends Object> guessPropertyTypeFromEditors(String p0){ return null; }
    protected void copyCustomEditorsTo(PropertyEditorRegistry p0, String p1){}
    protected void copyDefaultEditorsTo(PropertyEditorRegistrySupport p0){}
    protected void registerDefaultEditors(){}
    public ConversionService getConversionService(){ return null; }
    public PropertyEditor findCustomEditor(Class<? extends Object> p0, String p1){ return null; }
    public PropertyEditor getDefaultEditor(Class<? extends Object> p0){ return null; }
    public PropertyEditorRegistrySupport(){}
    public boolean hasCustomEditorForElement(Class<? extends Object> p0, String p1){ return false; }
    public void overrideDefaultEditor(Class<? extends Object> p0, PropertyEditor p1){}
    public void registerCustomEditor(Class<? extends Object> p0, PropertyEditor p1){}
    public void registerCustomEditor(Class<? extends Object> p0, String p1, PropertyEditor p2){}
    public void setConversionService(ConversionService p0){}
    public void useConfigValueEditors(){}
}
