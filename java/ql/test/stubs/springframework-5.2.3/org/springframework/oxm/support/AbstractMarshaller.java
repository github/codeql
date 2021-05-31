package org.springframework.oxm.support;

import java.io.Reader;
import java.io.InputStream;
import org.springframework.oxm.Marshaller;
import org.springframework.oxm.Unmarshaller;

public abstract class AbstractMarshaller implements Marshaller, Unmarshaller {

    protected abstract Object unmarshalInputStream(InputStream var1);

    protected abstract Object unmarshalReader(Reader var1);
}
