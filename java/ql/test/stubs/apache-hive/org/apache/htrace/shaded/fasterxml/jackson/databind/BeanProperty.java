// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.BeanProperty for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind;

import java.lang.annotation.Annotation;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.PropertyMetadata;
import org.apache.htrace.shaded.fasterxml.jackson.databind.PropertyName;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedMember;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonObjectFormatVisitor;
import org.apache.htrace.shaded.fasterxml.jackson.databind.util.Annotations;
import org.apache.htrace.shaded.fasterxml.jackson.databind.util.Named;

public interface BeanProperty extends Named
{
    <A extends Annotation> A getAnnotation(java.lang.Class<A> p0);
    <A extends Annotation> A getContextAnnotation(java.lang.Class<A> p0);
    AnnotatedMember getMember();
    JavaType getType();
    PropertyMetadata getMetadata();
    PropertyName getFullName();
    PropertyName getWrapperName();
    String getName();
    boolean isRequired();
    static public class Std implements BeanProperty
    {
        protected Std() {}
        protected final AnnotatedMember _member = null;
        protected final Annotations _contextAnnotations = null;
        protected final JavaType _type = null;
        protected final PropertyMetadata _metadata = null;
        protected final PropertyName _name = null;
        protected final PropertyName _wrapperName = null;
        public <A extends Annotation> A getAnnotation(java.lang.Class<A> p0){ return null; }
        public <A extends Annotation> A getContextAnnotation(java.lang.Class<A> p0){ return null; }
        public AnnotatedMember getMember(){ return null; }
        public BeanProperty.Std withType(JavaType p0){ return null; }
        public JavaType getType(){ return null; }
        public PropertyMetadata getMetadata(){ return null; }
        public PropertyName getFullName(){ return null; }
        public PropertyName getWrapperName(){ return null; }
        public Std(PropertyName p0, JavaType p1, PropertyName p2, Annotations p3, AnnotatedMember p4, PropertyMetadata p5){}
        public Std(String p0, JavaType p1, PropertyName p2, Annotations p3, AnnotatedMember p4, boolean p5){}
        public String getName(){ return null; }
        public boolean isRequired(){ return false; }
        public void depositSchemaProperty(JsonObjectFormatVisitor p0){}
    }
    void depositSchemaProperty(JsonObjectFormatVisitor p0);
}
