// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedClass for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.introspect;

import java.lang.annotation.Annotation;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Type;
import java.util.List;
import java.util.Map;
import org.apache.htrace.shaded.fasterxml.jackson.databind.AnnotationIntrospector;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.Annotated;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedConstructor;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedField;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedMethod;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedMethodMap;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotationMap;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.ClassIntrospector;
import org.apache.htrace.shaded.fasterxml.jackson.databind.util.Annotations;

public class AnnotatedClass extends Annotated
{
    protected AnnotatedClass() {}
    protected AnnotatedConstructor _constructConstructor(Constructor<? extends Object> p0, boolean p1){ return null; }
    protected AnnotatedConstructor _defaultConstructor = null;
    protected AnnotatedField _constructField(Field p0){ return null; }
    protected AnnotatedMethod _constructCreatorMethod(Method p0){ return null; }
    protected AnnotatedMethod _constructMethod(Method p0){ return null; }
    protected AnnotatedMethodMap _memberMethods = null;
    protected AnnotationMap _classAnnotations = null;
    protected AnnotationMap _collectRelevantAnnotations(Annotation[] p0){ return null; }
    protected AnnotationMap getAllAnnotations(){ return null; }
    protected AnnotationMap[] _collectRelevantAnnotations(Annotation[][] p0){ return null; }
    protected List<AnnotatedConstructor> _constructors = null;
    protected List<AnnotatedField> _fields = null;
    protected List<AnnotatedMethod> _creatorMethods = null;
    protected Map<String, AnnotatedField> _findFields(Class<? extends Object> p0, Map<String, AnnotatedField> p1){ return null; }
    protected boolean _creatorsResolved = false;
    protected boolean _isIncludableMemberMethod(Method p0){ return false; }
    protected final AnnotationIntrospector _annotationIntrospector = null;
    protected final Class<? extends Object> _class = null;
    protected final Class<? extends Object> _primaryMixIn = null;
    protected final ClassIntrospector.MixInResolver _mixInResolver = null;
    protected final List<Class<? extends Object>> _superTypes = null;
    protected void _addClassMixIns(AnnotationMap p0, Class<? extends Object> p1){}
    protected void _addClassMixIns(AnnotationMap p0, Class<? extends Object> p1, Class<? extends Object> p2){}
    protected void _addConstructorMixIns(Class<? extends Object> p0){}
    protected void _addFactoryMixIns(Class<? extends Object> p0){}
    protected void _addFieldMixIns(Class<? extends Object> p0, Class<? extends Object> p1, Map<String, AnnotatedField> p2){}
    protected void _addMemberMethods(Class<? extends Object> p0, AnnotatedMethodMap p1, Class<? extends Object> p2, AnnotatedMethodMap p3){}
    protected void _addMethodMixIns(Class<? extends Object> p0, AnnotatedMethodMap p1, Class<? extends Object> p2, AnnotatedMethodMap p3){}
    protected void _addMixOvers(Constructor<? extends Object> p0, AnnotatedConstructor p1, boolean p2){}
    protected void _addMixOvers(Method p0, AnnotatedMethod p1, boolean p2){}
    protected void _addMixUnders(Method p0, AnnotatedMethod p1){}
    public <A extends Annotation> A getAnnotation(java.lang.Class<A> p0){ return null; }
    public AnnotatedClass withAnnotations(AnnotationMap p0){ return null; }
    public AnnotatedConstructor getDefaultConstructor(){ return null; }
    public AnnotatedMethod findMethod(String p0, Class<? extends Object>[] p1){ return null; }
    public Annotations getAnnotations(){ return null; }
    public Class<? extends Object> getAnnotated(){ return null; }
    public Class<? extends Object> getRawType(){ return null; }
    public Iterable<AnnotatedField> fields(){ return null; }
    public Iterable<AnnotatedMethod> memberMethods(){ return null; }
    public Iterable<Annotation> annotations(){ return null; }
    public List<AnnotatedConstructor> getConstructors(){ return null; }
    public List<AnnotatedMethod> getStaticMethods(){ return null; }
    public String getName(){ return null; }
    public String toString(){ return null; }
    public Type getGenericType(){ return null; }
    public boolean hasAnnotations(){ return false; }
    public int getFieldCount(){ return 0; }
    public int getMemberMethodCount(){ return 0; }
    public int getModifiers(){ return 0; }
    public static AnnotatedClass construct(Class<? extends Object> p0, AnnotationIntrospector p1, ClassIntrospector.MixInResolver p2){ return null; }
    public static AnnotatedClass constructWithoutSuperTypes(Class<? extends Object> p0, AnnotationIntrospector p1, ClassIntrospector.MixInResolver p2){ return null; }
}
