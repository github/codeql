package org.springframework.oxm.xstream;

import java.io.Reader;
import java.io.InputStream;
import org.springframework.lang.Nullable;
import com.thoughtworks.xstream.converters.DataHolder;
import org.springframework.beans.factory.BeanClassLoaderAware;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.oxm.support.AbstractMarshaller;


public class XStreamMarshaller extends AbstractMarshaller implements BeanClassLoaderAware, InitializingBean {

    public XStreamMarshaller() { }

    public void afterPropertiesSet() { }

    public void setBeanClassLoader(ClassLoader classLoader) { }

    public Object unmarshalInputStream(InputStream inputStream) {
        return null;
    }

    public Object unmarshalInputStream(InputStream inputStream, @Nullable DataHolder dataHolder) {
        return null;
    }

    public Object unmarshalReader(Reader reader) {
        return null;
    }

    public Object unmarshalReader(Reader reader, @Nullable DataHolder dataHolder) {
        return null;
    }
}
