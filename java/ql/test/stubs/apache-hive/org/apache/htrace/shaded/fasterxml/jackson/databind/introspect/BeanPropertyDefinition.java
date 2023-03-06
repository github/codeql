// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.BeanPropertyDefinition for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.introspect;

import org.apache.htrace.shaded.fasterxml.jackson.databind.AnnotationIntrospector;
import org.apache.htrace.shaded.fasterxml.jackson.databind.PropertyMetadata;
import org.apache.htrace.shaded.fasterxml.jackson.databind.PropertyName;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedField;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedMember;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedMethod;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedParameter;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.ObjectIdInfo;
import org.apache.htrace.shaded.fasterxml.jackson.databind.util.Named;

abstract public class BeanPropertyDefinition implements Named
{
    public AnnotatedMember getPrimaryMember(){ return null; }
    public AnnotationIntrospector.ReferenceProperty findReferenceType(){ return null; }
    public BeanPropertyDefinition withName(String p0){ return null; }
    public BeanPropertyDefinition(){}
    public Class<? extends Object>[] findViews(){ return null; }
    public ObjectIdInfo findObjectIdInfo(){ return null; }
    public abstract AnnotatedField getField();
    public abstract AnnotatedMember getAccessor();
    public abstract AnnotatedMember getMutator();
    public abstract AnnotatedMember getNonConstructorMutator();
    public abstract AnnotatedMethod getGetter();
    public abstract AnnotatedMethod getSetter();
    public abstract AnnotatedParameter getConstructorParameter();
    public abstract BeanPropertyDefinition withName(PropertyName p0);
    public abstract BeanPropertyDefinition withSimpleName(String p0);
    public abstract PropertyMetadata getMetadata();
    public abstract PropertyName getFullName();
    public abstract PropertyName getWrapperName();
    public abstract String getInternalName();
    public abstract String getName();
    public abstract boolean hasConstructorParameter();
    public abstract boolean hasField();
    public abstract boolean hasGetter();
    public abstract boolean hasSetter();
    public abstract boolean isExplicitlyIncluded();
    public boolean couldDeserialize(){ return false; }
    public boolean couldSerialize(){ return false; }
    public boolean isExplicitlyNamed(){ return false; }
    public boolean isTypeId(){ return false; }
    public final boolean isRequired(){ return false; }
}
