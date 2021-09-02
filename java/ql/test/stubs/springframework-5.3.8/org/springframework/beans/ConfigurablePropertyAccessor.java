// Generated automatically from org.springframework.beans.ConfigurablePropertyAccessor for testing purposes

package org.springframework.beans;

import org.springframework.beans.PropertyAccessor;
import org.springframework.beans.PropertyEditorRegistry;
import org.springframework.beans.TypeConverter;
import org.springframework.core.convert.ConversionService;

public interface ConfigurablePropertyAccessor extends PropertyAccessor, PropertyEditorRegistry, TypeConverter
{
    ConversionService getConversionService();
    boolean isAutoGrowNestedPaths();
    boolean isExtractOldValueForEditor();
    void setAutoGrowNestedPaths(boolean p0);
    void setConversionService(ConversionService p0);
    void setExtractOldValueForEditor(boolean p0);
}
