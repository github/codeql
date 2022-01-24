package com.caucho.hessian.io;

import java.io.IOException;

public interface Deserializer {
    Class<?> getType();

    boolean isReadResolve();

    Object readObject(AbstractHessianInput var1) throws IOException;

    Object readList(AbstractHessianInput var1, int var2) throws IOException;

    Object readLengthList(AbstractHessianInput var1, int var2) throws IOException;

    Object readMap(AbstractHessianInput var1) throws IOException;

    Object[] createFields(int var1);

    Object createField(String var1);

    Object readObject(AbstractHessianInput var1, Object[] var2) throws IOException;

    Object readObject(AbstractHessianInput var1, String[] var2) throws IOException;
}

