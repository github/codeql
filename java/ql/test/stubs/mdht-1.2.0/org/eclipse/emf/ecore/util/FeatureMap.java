// Generated automatically from org.eclipse.emf.ecore.util.FeatureMap for testing purposes

package org.eclipse.emf.ecore.util;

import java.util.Collection;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.util.EContentsEList;

public interface FeatureMap extends org.eclipse.emf.common.util.EList<FeatureMap.Entry>
{
    <T> org.eclipse.emf.common.util.EList<T> list(EStructuralFeature p0);
    EStructuralFeature getEStructuralFeature(int p0);
    FeatureMap.ValueListIterator<Object> valueListIterator();
    FeatureMap.ValueListIterator<Object> valueListIterator(int p0);
    Object get(EStructuralFeature p0, boolean p1);
    Object getValue(int p0);
    Object setValue(int p0, Object p1);
    boolean add(EStructuralFeature p0, Object p1);
    boolean addAll(EStructuralFeature p0, Collection<? extends Object> p1);
    boolean addAll(int p0, EStructuralFeature p1, Collection<? extends Object> p2);
    boolean isSet(EStructuralFeature p0);
    static public interface Entry
    {
        EStructuralFeature getEStructuralFeature();
        Object getValue();
    }
    static public interface ValueListIterator<E> extends EContentsEList.FeatureListIterator<E>
    {
        void add(EStructuralFeature p0, Object p1);
    }
    void add(int p0, EStructuralFeature p1, Object p2);
    void set(EStructuralFeature p0, Object p1);
    void unset(EStructuralFeature p0);
}
