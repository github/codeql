// Generated automatically from com.fasterxml.jackson.databind.deser.BeanDeserializerBuilder for testing purposes

package com.fasterxml.jackson.databind.deser;

import com.fasterxml.jackson.databind.BeanDescription;
import com.fasterxml.jackson.databind.DeserializationConfig;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.PropertyName;
import com.fasterxml.jackson.databind.annotation.JsonPOJOBuilder;
import com.fasterxml.jackson.databind.deser.AbstractDeserializer;
import com.fasterxml.jackson.databind.deser.SettableAnyProperty;
import com.fasterxml.jackson.databind.deser.SettableBeanProperty;
import com.fasterxml.jackson.databind.deser.ValueInstantiator;
import com.fasterxml.jackson.databind.deser.impl.ObjectIdReader;
import com.fasterxml.jackson.databind.deser.impl.ValueInjector;
import com.fasterxml.jackson.databind.introspect.AnnotatedMember;
import com.fasterxml.jackson.databind.introspect.AnnotatedMethod;
import com.fasterxml.jackson.databind.util.Annotations;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class BeanDeserializerBuilder
{
    protected BeanDeserializerBuilder() {}
    protected AnnotatedMethod _buildMethod = null;
    protected BeanDeserializerBuilder(BeanDeserializerBuilder p0){}
    protected HashMap<String, SettableBeanProperty> _backRefProperties = null;
    protected HashSet<String> _ignorableProps = null;
    protected JsonPOJOBuilder.Value _builderConfig = null;
    protected List<ValueInjector> _injectables = null;
    protected ObjectIdReader _objectIdReader = null;
    protected SettableAnyProperty _anySetter = null;
    protected ValueInstantiator _valueInstantiator = null;
    protected boolean _ignoreAllUnknown = false;
    protected final BeanDescription _beanDesc = null;
    protected final Map<String, SettableBeanProperty> _properties = null;
    protected final boolean _caseInsensitivePropertyComparison = false;
    protected final boolean _defaultViewInclusion = false;
    public AbstractDeserializer buildAbstract(){ return null; }
    public AnnotatedMethod getBuildMethod(){ return null; }
    public BeanDeserializerBuilder(BeanDescription p0, DeserializationConfig p1){}
    public Iterator<SettableBeanProperty> getProperties(){ return null; }
    public JsonDeserializer<? extends Object> build(){ return null; }
    public JsonDeserializer<? extends Object> buildBuilderBased(JavaType p0, String p1){ return null; }
    public JsonPOJOBuilder.Value getBuilderConfig(){ return null; }
    public List<ValueInjector> getInjectables(){ return null; }
    public ObjectIdReader getObjectIdReader(){ return null; }
    public SettableAnyProperty getAnySetter(){ return null; }
    public SettableBeanProperty findProperty(PropertyName p0){ return null; }
    public SettableBeanProperty removeProperty(PropertyName p0){ return null; }
    public ValueInstantiator getValueInstantiator(){ return null; }
    public boolean hasProperty(PropertyName p0){ return false; }
    public void addBackReferenceProperty(String p0, SettableBeanProperty p1){}
    public void addCreatorProperty(SettableBeanProperty p0){}
    public void addIgnorable(String p0){}
    public void addInjectable(PropertyName p0, JavaType p1, Annotations p2, AnnotatedMember p3, Object p4){}
    public void addOrReplaceProperty(SettableBeanProperty p0, boolean p1){}
    public void addProperty(SettableBeanProperty p0){}
    public void setAnySetter(SettableAnyProperty p0){}
    public void setIgnoreUnknownProperties(boolean p0){}
    public void setObjectIdReader(ObjectIdReader p0){}
    public void setPOJOBuilder(AnnotatedMethod p0, JsonPOJOBuilder.Value p1){}
    public void setValueInstantiator(ValueInstantiator p0){}
}
