// Generated automatically from com.fasterxml.jackson.databind.introspect.ConcreteBeanPropertyBase for testing purposes

package com.fasterxml.jackson.databind.introspect;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.AnnotationIntrospector;
import com.fasterxml.jackson.databind.BeanProperty;
import com.fasterxml.jackson.databind.PropertyMetadata;
import com.fasterxml.jackson.databind.cfg.MapperConfig;
import java.io.Serializable;

abstract public class ConcreteBeanPropertyBase implements BeanProperty, Serializable
{
    protected ConcreteBeanPropertyBase() {}
    protected ConcreteBeanPropertyBase(ConcreteBeanPropertyBase p0){}
    protected ConcreteBeanPropertyBase(PropertyMetadata p0){}
    protected JsonFormat.Value _format = null;
    protected final PropertyMetadata _metadata = null;
    public JsonFormat.Value findPropertyFormat(MapperConfig<? extends Object> p0, Class<? extends Object> p1){ return null; }
    public JsonInclude.Value findPropertyInclusion(MapperConfig<? extends Object> p0, Class<? extends Object> p1){ return null; }
    public PropertyMetadata getMetadata(){ return null; }
    public boolean isRequired(){ return false; }
    public boolean isVirtual(){ return false; }
    public final JsonFormat.Value findFormatOverrides(AnnotationIntrospector p0){ return null; }
}
