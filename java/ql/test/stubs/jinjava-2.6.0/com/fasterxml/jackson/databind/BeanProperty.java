// Generated automatically from com.fasterxml.jackson.databind.BeanProperty for testing purposes

package com.fasterxml.jackson.databind;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.AnnotationIntrospector;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.PropertyMetadata;
import com.fasterxml.jackson.databind.PropertyName;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.cfg.MapperConfig;
import com.fasterxml.jackson.databind.introspect.AnnotatedMember;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonObjectFormatVisitor;
import com.fasterxml.jackson.databind.util.Annotations;
import com.fasterxml.jackson.databind.util.Named;
import java.lang.annotation.Annotation;

public interface BeanProperty extends Named
{
    <A extends Annotation> A getAnnotation(Class<A> p0);
    <A extends Annotation> A getContextAnnotation(Class<A> p0);
    AnnotatedMember getMember();
    JavaType getType();
    JsonFormat.Value findFormatOverrides(AnnotationIntrospector p0);
    JsonFormat.Value findPropertyFormat(MapperConfig<? extends Object> p0, Class<? extends Object> p1);
    JsonInclude.Value findPropertyInclusion(MapperConfig<? extends Object> p0, Class<? extends Object> p1);
    PropertyMetadata getMetadata();
    PropertyName getFullName();
    PropertyName getWrapperName();
    String getName();
    boolean isRequired();
    boolean isVirtual();
    static JsonFormat.Value EMPTY_FORMAT = null;
    static JsonInclude.Value EMPTY_INCLUDE = null;
    static public class Std implements BeanProperty
    {
        protected Std() {}
        protected final AnnotatedMember _member = null;
        protected final Annotations _contextAnnotations = null;
        protected final JavaType _type = null;
        protected final PropertyMetadata _metadata = null;
        protected final PropertyName _name = null;
        protected final PropertyName _wrapperName = null;
        public <A extends Annotation> A getAnnotation(Class<A> p0){ return null; }
        public <A extends Annotation> A getContextAnnotation(Class<A> p0){ return null; }
        public AnnotatedMember getMember(){ return null; }
        public BeanProperty.Std withType(JavaType p0){ return null; }
        public JavaType getType(){ return null; }
        public JsonFormat.Value findFormatOverrides(AnnotationIntrospector p0){ return null; }
        public JsonFormat.Value findPropertyFormat(MapperConfig<? extends Object> p0, Class<? extends Object> p1){ return null; }
        public JsonInclude.Value findPropertyInclusion(MapperConfig<? extends Object> p0, Class<? extends Object> p1){ return null; }
        public PropertyMetadata getMetadata(){ return null; }
        public PropertyName getFullName(){ return null; }
        public PropertyName getWrapperName(){ return null; }
        public Std(BeanProperty.Std p0, JavaType p1){}
        public Std(PropertyName p0, JavaType p1, PropertyName p2, Annotations p3, AnnotatedMember p4, PropertyMetadata p5){}
        public Std(String p0, JavaType p1, PropertyName p2, Annotations p3, AnnotatedMember p4, boolean p5){}
        public String getName(){ return null; }
        public boolean isRequired(){ return false; }
        public boolean isVirtual(){ return false; }
        public void depositSchemaProperty(JsonObjectFormatVisitor p0, SerializerProvider p1){}
    }
    void depositSchemaProperty(JsonObjectFormatVisitor p0, SerializerProvider p1);
}
