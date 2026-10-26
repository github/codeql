// Generated automatically from org.jdbi.v3.core.result.RowView for testing purposes

package org.jdbi.v3.core.result;

import java.lang.reflect.Type;
import org.jdbi.v3.core.generic.GenericType;
import org.jdbi.v3.core.qualifier.QualifiedType;

abstract public class RowView
{
    public <T> T getColumn(String p0, java.lang.Class<T> p1){ return null; }
    public <T> T getColumn(String p0, org.jdbi.v3.core.generic.GenericType<T> p1){ return null; }
    public <T> T getColumn(int p0, java.lang.Class<T> p1){ return null; }
    public <T> T getColumn(int p0, org.jdbi.v3.core.generic.GenericType<T> p1){ return null; }
    public <T> T getRow(java.lang.Class<T> p0){ return null; }
    public <T> T getRow(org.jdbi.v3.core.generic.GenericType<T> p0){ return null; }
    public Object getColumn(String p0, Type p1){ return null; }
    public Object getColumn(int p0, Type p1){ return null; }
    public RowView(){}
    public abstract <T> T getColumn(String p0, org.jdbi.v3.core.qualifier.QualifiedType<T> p1);
    public abstract <T> T getColumn(int p0, org.jdbi.v3.core.qualifier.QualifiedType<T> p1);
    public abstract Object getRow(Type p0);
}
