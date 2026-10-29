// Generated automatically from com.fasterxml.jackson.databind.introspect.BeanPropertyDefinition for testing purposes

package com.fasterxml.jackson.databind.introspect;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.AnnotationIntrospector;
import com.fasterxml.jackson.databind.PropertyMetadata;
import com.fasterxml.jackson.databind.PropertyName;
import com.fasterxml.jackson.databind.introspect.AnnotatedField;
import com.fasterxml.jackson.databind.introspect.AnnotatedMember;
import com.fasterxml.jackson.databind.introspect.AnnotatedMethod;
import com.fasterxml.jackson.databind.introspect.AnnotatedParameter;
import com.fasterxml.jackson.databind.introspect.ObjectIdInfo;
import com.fasterxml.jackson.databind.util.Named;
import java.util.Iterator;

abstract public class BeanPropertyDefinition implements Named
{
    protected static JsonInclude.Value EMPTY_INCLUDE = null;
    public AnnotationIntrospector.ReferenceProperty findReferenceType(){ return null; }
    public BeanPropertyDefinition(){}
    public Class<? extends Object>[] findViews(){ return null; }
    public Iterator<AnnotatedParameter> getConstructorParameters(){ return null; }
    public JsonInclude.Value findInclusion(){ return null; }
    public ObjectIdInfo findObjectIdInfo(){ return null; }
    public abstract AnnotatedField getField();
    public abstract AnnotatedMember getAccessor();
    public abstract AnnotatedMember getMutator();
    public abstract AnnotatedMember getNonConstructorMutator();
    public abstract AnnotatedMember getPrimaryMember();
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
    public boolean hasName(PropertyName p0){ return false; }
    public boolean isExplicitlyNamed(){ return false; }
    public boolean isRequired(){ return false; }
    public boolean isTypeId(){ return false; }
}
