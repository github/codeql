// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.AnnotationIntrospector for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind;

import java.io.Serializable;
import java.lang.annotation.Annotation;
import java.util.Collection;
import java.util.List;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.JsonFormat;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.JsonInclude;
import org.apache.htrace.shaded.fasterxml.jackson.core.Version;
import org.apache.htrace.shaded.fasterxml.jackson.core.Versioned;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.PropertyName;
import org.apache.htrace.shaded.fasterxml.jackson.databind.annotation.JsonPOJOBuilder;
import org.apache.htrace.shaded.fasterxml.jackson.databind.annotation.JsonSerialize;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.MapperConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.Annotated;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedClass;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedMember;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedMethod;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.ObjectIdInfo;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.VisibilityChecker;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.NamedType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeResolverBuilder;
import org.apache.htrace.shaded.fasterxml.jackson.databind.util.NameTransformer;

abstract public class AnnotationIntrospector implements Serializable, Versioned
{
    public AnnotationIntrospector(){}
    public AnnotationIntrospector.ReferenceProperty findReferenceType(AnnotatedMember p0){ return null; }
    public Boolean findIgnoreUnknownProperties(AnnotatedClass p0){ return null; }
    public Boolean findSerializationSortAlphabetically(Annotated p0){ return null; }
    public Boolean findSerializationSortAlphabetically(AnnotatedClass p0){ return null; }
    public Boolean hasRequiredMarker(AnnotatedMember p0){ return null; }
    public Boolean isIgnorableType(AnnotatedClass p0){ return null; }
    public Boolean isTypeId(AnnotatedMember p0){ return null; }
    public Class<? extends Object> findDeserializationContentType(Annotated p0, JavaType p1){ return null; }
    public Class<? extends Object> findDeserializationKeyType(Annotated p0, JavaType p1){ return null; }
    public Class<? extends Object> findDeserializationType(Annotated p0, JavaType p1){ return null; }
    public Class<? extends Object> findPOJOBuilder(AnnotatedClass p0){ return null; }
    public Class<? extends Object> findSerializationContentType(Annotated p0, JavaType p1){ return null; }
    public Class<? extends Object> findSerializationKeyType(Annotated p0, JavaType p1){ return null; }
    public Class<? extends Object> findSerializationType(Annotated p0){ return null; }
    public Class<? extends Object>[] findViews(Annotated p0){ return null; }
    public Collection<AnnotationIntrospector> allIntrospectors(){ return null; }
    public Collection<AnnotationIntrospector> allIntrospectors(Collection<AnnotationIntrospector> p0){ return null; }
    public Integer findPropertyIndex(Annotated p0){ return null; }
    public JsonFormat.Value findFormat(Annotated p0){ return null; }
    public JsonInclude.Include findSerializationInclusion(Annotated p0, JsonInclude.Include p1){ return null; }
    public JsonPOJOBuilder.Value findPOJOBuilderConfig(AnnotatedClass p0){ return null; }
    public JsonSerialize.Typing findSerializationTyping(Annotated p0){ return null; }
    public List<NamedType> findSubtypes(Annotated p0){ return null; }
    public NameTransformer findUnwrappingNameTransformer(AnnotatedMember p0){ return null; }
    public Object findContentDeserializer(Annotated p0){ return null; }
    public Object findContentSerializer(Annotated p0){ return null; }
    public Object findDeserializationContentConverter(AnnotatedMember p0){ return null; }
    public Object findDeserializationConverter(Annotated p0){ return null; }
    public Object findDeserializer(Annotated p0){ return null; }
    public Object findFilterId(Annotated p0){ return null; }
    public Object findFilterId(AnnotatedClass p0){ return null; }
    public Object findInjectableValueId(AnnotatedMember p0){ return null; }
    public Object findKeyDeserializer(Annotated p0){ return null; }
    public Object findKeySerializer(Annotated p0){ return null; }
    public Object findNamingStrategy(AnnotatedClass p0){ return null; }
    public Object findNullSerializer(Annotated p0){ return null; }
    public Object findSerializationContentConverter(AnnotatedMember p0){ return null; }
    public Object findSerializationConverter(Annotated p0){ return null; }
    public Object findSerializer(Annotated p0){ return null; }
    public Object findValueInstantiator(AnnotatedClass p0){ return null; }
    public ObjectIdInfo findObjectIdInfo(Annotated p0){ return null; }
    public ObjectIdInfo findObjectReferenceInfo(Annotated p0, ObjectIdInfo p1){ return null; }
    public PropertyName findNameForDeserialization(Annotated p0){ return null; }
    public PropertyName findNameForSerialization(Annotated p0){ return null; }
    public PropertyName findRootName(AnnotatedClass p0){ return null; }
    public PropertyName findWrapperName(Annotated p0){ return null; }
    public String findEnumValue(Enum<? extends Object> p0){ return null; }
    public String findImplicitPropertyName(AnnotatedMember p0){ return null; }
    public String findPropertyDescription(Annotated p0){ return null; }
    public String findTypeName(AnnotatedClass p0){ return null; }
    public String[] findPropertiesToIgnore(Annotated p0){ return null; }
    public String[] findSerializationPropertyOrder(AnnotatedClass p0){ return null; }
    public TypeResolverBuilder<? extends Object> findPropertyContentTypeResolver(MapperConfig<? extends Object> p0, AnnotatedMember p1, JavaType p2){ return null; }
    public TypeResolverBuilder<? extends Object> findPropertyTypeResolver(MapperConfig<? extends Object> p0, AnnotatedMember p1, JavaType p2){ return null; }
    public TypeResolverBuilder<? extends Object> findTypeResolver(MapperConfig<? extends Object> p0, AnnotatedClass p1, JavaType p2){ return null; }
    public VisibilityChecker<? extends Object> findAutoDetectVisibility(AnnotatedClass p0, VisibilityChecker<? extends Object> p1){ return null; }
    public abstract Version version();
    public boolean hasAnyGetterAnnotation(AnnotatedMethod p0){ return false; }
    public boolean hasAnySetterAnnotation(AnnotatedMethod p0){ return false; }
    public boolean hasAsValueAnnotation(AnnotatedMethod p0){ return false; }
    public boolean hasCreatorAnnotation(Annotated p0){ return false; }
    public boolean hasIgnoreMarker(AnnotatedMember p0){ return false; }
    public boolean isAnnotationBundle(Annotation p0){ return false; }
    public static AnnotationIntrospector nopInstance(){ return null; }
    public static AnnotationIntrospector pair(AnnotationIntrospector p0, AnnotationIntrospector p1){ return null; }
    static public class ReferenceProperty
    {
        protected ReferenceProperty() {}
        public AnnotationIntrospector.ReferenceProperty.Type getType(){ return null; }
        public ReferenceProperty(AnnotationIntrospector.ReferenceProperty.Type p0, String p1){}
        public String getName(){ return null; }
        public boolean isBackReference(){ return false; }
        public boolean isManagedReference(){ return false; }
        public static AnnotationIntrospector.ReferenceProperty back(String p0){ return null; }
        public static AnnotationIntrospector.ReferenceProperty managed(String p0){ return null; }
        static public enum Type
        {
            BACK_REFERENCE, MANAGED_REFERENCE;
            private Type() {}
        }
    }
}
