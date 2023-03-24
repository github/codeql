// Generated automatically from com.fasterxml.jackson.databind.AnnotationIntrospector for testing purposes

package com.fasterxml.jackson.databind;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.Version;
import com.fasterxml.jackson.core.Versioned;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.PropertyName;
import com.fasterxml.jackson.databind.annotation.JsonPOJOBuilder;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.cfg.MapperConfig;
import com.fasterxml.jackson.databind.introspect.Annotated;
import com.fasterxml.jackson.databind.introspect.AnnotatedClass;
import com.fasterxml.jackson.databind.introspect.AnnotatedMember;
import com.fasterxml.jackson.databind.introspect.AnnotatedMethod;
import com.fasterxml.jackson.databind.introspect.ObjectIdInfo;
import com.fasterxml.jackson.databind.introspect.VisibilityChecker;
import com.fasterxml.jackson.databind.jsontype.NamedType;
import com.fasterxml.jackson.databind.jsontype.TypeResolverBuilder;
import com.fasterxml.jackson.databind.ser.BeanPropertyWriter;
import com.fasterxml.jackson.databind.util.NameTransformer;
import java.io.Serializable;
import java.lang.annotation.Annotation;
import java.util.Collection;
import java.util.List;

abstract public class AnnotationIntrospector implements Serializable, Versioned
{
    protected <A extends Annotation> A _findAnnotation(Annotated p0, Class<A> p1){ return null; }
    protected boolean _hasAnnotation(Annotated p0, Class<? extends Annotation> p1){ return false; }
    protected boolean _hasOneOf(Annotated p0, Class<? extends Annotation>[] p1){ return false; }
    public AnnotatedMethod resolveSetterConflict(MapperConfig<? extends Object> p0, AnnotatedMethod p1, AnnotatedMethod p2){ return null; }
    public AnnotationIntrospector(){}
    public AnnotationIntrospector.ReferenceProperty findReferenceType(AnnotatedMember p0){ return null; }
    public Boolean findIgnoreUnknownProperties(AnnotatedClass p0){ return null; }
    public Boolean findSerializationSortAlphabetically(Annotated p0){ return null; }
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
    public JavaType refineDeserializationType(MapperConfig<? extends Object> p0, Annotated p1, JavaType p2){ return null; }
    public JavaType refineSerializationType(MapperConfig<? extends Object> p0, Annotated p1, JavaType p2){ return null; }
    public JsonCreator.Mode findCreatorBinding(Annotated p0){ return null; }
    public JsonFormat.Value findFormat(Annotated p0){ return null; }
    public JsonInclude.Include findSerializationInclusion(Annotated p0, JsonInclude.Include p1){ return null; }
    public JsonInclude.Include findSerializationInclusionForContent(Annotated p0, JsonInclude.Include p1){ return null; }
    public JsonInclude.Value findPropertyInclusion(Annotated p0){ return null; }
    public JsonPOJOBuilder.Value findPOJOBuilderConfig(AnnotatedClass p0){ return null; }
    public JsonProperty.Access findPropertyAccess(Annotated p0){ return null; }
    public JsonSerialize.Typing findSerializationTyping(Annotated p0){ return null; }
    public List<NamedType> findSubtypes(Annotated p0){ return null; }
    public NameTransformer findUnwrappingNameTransformer(AnnotatedMember p0){ return null; }
    public Object findContentDeserializer(Annotated p0){ return null; }
    public Object findContentSerializer(Annotated p0){ return null; }
    public Object findDeserializationContentConverter(AnnotatedMember p0){ return null; }
    public Object findDeserializationConverter(Annotated p0){ return null; }
    public Object findDeserializer(Annotated p0){ return null; }
    public Object findFilterId(Annotated p0){ return null; }
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
    public String findClassDescription(AnnotatedClass p0){ return null; }
    public String findEnumValue(Enum<? extends Object> p0){ return null; }
    public String findImplicitPropertyName(AnnotatedMember p0){ return null; }
    public String findPropertyDefaultValue(Annotated p0){ return null; }
    public String findPropertyDescription(Annotated p0){ return null; }
    public String findTypeName(AnnotatedClass p0){ return null; }
    public String[] findEnumValues(Class<? extends Object> p0, Enum<? extends Object>[] p1, String[] p2){ return null; }
    public String[] findPropertiesToIgnore(Annotated p0){ return null; }
    public String[] findPropertiesToIgnore(Annotated p0, boolean p1){ return null; }
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
    public void findAndAddVirtualProperties(MapperConfig<? extends Object> p0, AnnotatedClass p1, List<BeanPropertyWriter> p2){}
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
