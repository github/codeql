// Generated automatically from org.apache.thrift.TBase for testing purposes

package org.apache.thrift;

import java.io.Serializable;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.protocol.TProtocol;

public interface TBase<T extends TBase<? extends Object, ? extends Object>, F extends TFieldIdEnum>
        extends Serializable, java.lang.Comparable<T> {
    F fieldForId(int p0);

    Object getFieldValue(F p0);

    TBase<T, F> deepCopy();

    boolean isSet(F p0);

    void clear();

    void read(TProtocol p0);

    void setFieldValue(F p0, Object p1);

    void write(TProtocol p0);
}
