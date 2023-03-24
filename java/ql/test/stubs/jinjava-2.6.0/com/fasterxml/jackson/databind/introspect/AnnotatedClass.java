// Generated automatically from com.fasterxml.jackson.databind.introspect.AnnotatedClass for testing purposes

package com.fasterxml.jackson.databind.introspect;

import com.fasterxml.jackson.databind.AnnotationIntrospector;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.cfg.MapperConfig;
import com.fasterxml.jackson.databind.introspect.Annotated;
import com.fasterxml.jackson.databind.introspect.AnnotatedConstructor;
import com.fasterxml.jackson.databind.introspect.AnnotatedField;
import com.fasterxml.jackson.databind.introspect.AnnotatedMethod;
import com.fasterxml.jackson.databind.introspect.AnnotatedMethodMap;
import com.fasterxml.jackson.databind.introspect.AnnotationMap;
import com.fasterxml.jackson.databind.introspect.ClassIntrospector;
import com.fasterxml.jackson.databind.introspect.TypeResolutionContext;
import com.fasterxml.jackson.databind.type.TypeBindings;
import com.fasterxml.jackson.databind.type.TypeFactory;
import com.fasterxml.jackson.databind.util.Annotations;
import com.fasterxml.jackson.databind.util.ClassUtil;
import java.lang.annotation.Annotation;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Type;
import java.util.List;
import java.util.Map;

public class AnnotatedClass extends Annotated implements TypeResolutionContext
{
    protected AnnotatedClass() {}
    protected AnnotatedConstructor _constructDefaultConstructor(ClassUtil.Ctor p0, TypeResolutionContext p1){ return null; }
    protected AnnotatedConstructor _constructNonDefaultConstructor(ClassUtil.Ctor p0, TypeResolutionContext p1){ return null; }
    protected AnnotatedConstructor _defaultConstructor = null;
    protected AnnotatedField _constructField(Field p0, TypeResolutionContext p1){ return null; }
    protected AnnotatedMethod _constructCreatorMethod(Method p0, TypeResolutionContext p1){ return null; }
    protected AnnotatedMethod _constructMethod(Method p0, TypeResolutionContext p1){ return null; }
    protected AnnotatedMethodMap _memberMethods = null;
    protected AnnotationMap _classAnnotations = null;
    protected AnnotationMap _collectRelevantAnnotations(Annotation[] p0){ return null; }
    protected AnnotationMap getAllAnnotations(){ return null; }
    protected AnnotationMap[] _collectRelevantAnnotations(Annotation[][] p0){ return null; }
    protected List<AnnotatedConstructor> _constructors = null;
    protected List<AnnotatedField> _fields = null;
    protected List<AnnotatedMethod> _creatorMethods = null;
    protected Map<String, AnnotatedField> _findFields(JavaType p0, TypeResolutionContext p1, Map<String, AnnotatedField> p2){ return null; }
    protected Method[] _findClassMethods(Class<? extends Object> p0){ return null; }
    protected boolean _creatorsResolved = false;
    protected boolean _isIncludableMemberMethod(Method p0){ return false; }
    protected final AnnotationIntrospector _annotationIntrospector = null;
    protected final Class<? extends Object> _class = null;
    protected final Class<? extends Object> _primaryMixIn = null;
    protected final ClassIntrospector.MixInResolver _mixInResolver = null;
    protected final JavaType _type = null;
    protected final List<JavaType> _superTypes = null;
    protected final TypeBindings _bindings = null;
    protected final TypeFactory _typeFactory = null;
    protected void _addClassMixIns(AnnotationMap p0, Class<? extends Object> p1){}
    protected void _addClassMixIns(AnnotationMap p0, Class<? extends Object> p1, Class<? extends Object> p2){}
    protected void _addClassMixIns(AnnotationMap p0, JavaType p1){}
    protected void _addConstructorMixIns(Class<? extends Object> p0){}
    protected void _addFactoryMixIns(Class<? extends Object> p0){}
    protected void _addFieldMixIns(Class<? extends Object> p0, Class<? extends Object> p1, Map<String, AnnotatedField> p2){}
    protected void _addMemberMethods(Class<? extends Object> p0, TypeResolutionContext p1, AnnotatedMethodMap p2, Class<? extends Object> p3, AnnotatedMethodMap p4){}
    protected void _addMethodMixIns(Class<? extends Object> p0, AnnotatedMethodMap p1, Class<? extends Object> p2, AnnotatedMethodMap p3){}
    protected void _addMixOvers(Constructor<? extends Object> p0, AnnotatedConstructor p1, boolean p2){}
    protected void _addMixOvers(Method p0, AnnotatedMethod p1, boolean p2){}
    protected void _addMixUnders(Method p0, AnnotatedMethod p1){}
    public <A extends Annotation> A getAnnotation(Class<A> p0){ return null; }
    public AnnotatedClass withAnnotations(AnnotationMap p0){ return null; }
    public AnnotatedConstructor getDefaultConstructor(){ return null; }
    public AnnotatedMethod findMethod(String p0, Class<? extends Object>[] p1){ return null; }
    public Annotations getAnnotations(){ return null; }
    public Class<? extends Object> getAnnotated(){ return null; }
    public Class<? extends Object> getRawType(){ return null; }
    public Iterable<AnnotatedField> fields(){ return null; }
    public Iterable<AnnotatedMethod> memberMethods(){ return null; }
    public Iterable<Annotation> annotations(){ return null; }
    public JavaType getType(){ return null; }
    public JavaType resolveType(Type p0){ return null; }
    public List<AnnotatedConstructor> getConstructors(){ return null; }
    public List<AnnotatedMethod> getStaticMethods(){ return null; }
    public String getName(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean hasAnnotation(Class<? extends Object> p0){ return false; }
    public boolean hasAnnotations(){ return false; }
    public boolean hasOneOf(Class<? extends Annotation>[] p0){ return false; }
    public int getFieldCount(){ return 0; }
    public int getMemberMethodCount(){ return 0; }
    public int getModifiers(){ return 0; }
    public int hashCode(){ return 0; }
    public static AnnotatedClass construct(JavaType p0, MapperConfig<? extends Object> p1){ return null; }
    public static AnnotatedClass construct(JavaType p0, MapperConfig<? extends Object> p1, ClassIntrospector.MixInResolver p2){ return null; }
    public static AnnotatedClass constructWithoutSuperTypes(Class<? extends Object> p0, MapperConfig<? extends Object> p1){ return null; }
    public static AnnotatedClass constructWithoutSuperTypes(Class<? extends Object> p0, MapperConfig<? extends Object> p1, ClassIntrospector.MixInResolver p2){ return null; }
}
