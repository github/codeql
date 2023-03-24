// Generated automatically from org.apache.sshd.common.Factory for testing purposes

package org.apache.sshd.common;

import java.util.function.Supplier;

public interface Factory<T> extends Supplier<T>
{
    T create();
    default T get(){ return null; }
}
