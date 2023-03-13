// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.PropertyNamingStrategy for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind;

import java.io.Serializable;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.MapperConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedField;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedMethod;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedParameter;

abstract public class PropertyNamingStrategy implements Serializable
{
    public PropertyNamingStrategy(){}
    public String nameForConstructorParameter(MapperConfig<? extends Object> p0, AnnotatedParameter p1, String p2){ return null; }
    public String nameForField(MapperConfig<? extends Object> p0, AnnotatedField p1, String p2){ return null; }
    public String nameForGetterMethod(MapperConfig<? extends Object> p0, AnnotatedMethod p1, String p2){ return null; }
    public String nameForSetterMethod(MapperConfig<? extends Object> p0, AnnotatedMethod p1, String p2){ return null; }
    public static PropertyNamingStrategy CAMEL_CASE_TO_LOWER_CASE_WITH_UNDERSCORES = null;
    public static PropertyNamingStrategy LOWER_CASE = null;
    public static PropertyNamingStrategy PASCAL_CASE_TO_CAMEL_CASE = null;
}
