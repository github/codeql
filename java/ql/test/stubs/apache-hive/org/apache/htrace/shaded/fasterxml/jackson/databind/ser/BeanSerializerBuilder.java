// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.ser.BeanSerializerBuilder for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.ser;

import java.util.List;
import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanDescription;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializationConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedClass;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedMember;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.AnyGetterWriter;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.BeanPropertyWriter;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.BeanSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.impl.ObjectIdWriter;

public class BeanSerializerBuilder
{
    protected BeanSerializerBuilder() {}
    protected AnnotatedMember _typeId = null;
    protected AnyGetterWriter _anyGetter = null;
    protected BeanPropertyWriter[] _filteredProperties = null;
    protected BeanSerializerBuilder(BeanSerializerBuilder p0){}
    protected List<BeanPropertyWriter> _properties = null;
    protected Object _filterId = null;
    protected ObjectIdWriter _objectIdWriter = null;
    protected SerializationConfig _config = null;
    protected final BeanDescription _beanDesc = null;
    protected void setConfig(SerializationConfig p0){}
    public AnnotatedClass getClassInfo(){ return null; }
    public AnnotatedMember getTypeId(){ return null; }
    public AnyGetterWriter getAnyGetter(){ return null; }
    public BeanDescription getBeanDescription(){ return null; }
    public BeanPropertyWriter[] getFilteredProperties(){ return null; }
    public BeanSerializer createDummy(){ return null; }
    public BeanSerializerBuilder(BeanDescription p0){}
    public JsonSerializer<? extends Object> build(){ return null; }
    public List<BeanPropertyWriter> getProperties(){ return null; }
    public Object getFilterId(){ return null; }
    public ObjectIdWriter getObjectIdWriter(){ return null; }
    public boolean hasProperties(){ return false; }
    public void setAnyGetter(AnyGetterWriter p0){}
    public void setFilterId(Object p0){}
    public void setFilteredProperties(BeanPropertyWriter[] p0){}
    public void setObjectIdWriter(ObjectIdWriter p0){}
    public void setProperties(List<BeanPropertyWriter> p0){}
    public void setTypeId(AnnotatedMember p0){}
}
