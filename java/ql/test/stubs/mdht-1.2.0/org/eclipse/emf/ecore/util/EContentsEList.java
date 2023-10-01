// Generated automatically from org.eclipse.emf.ecore.util.EContentsEList for testing purposes

package org.eclipse.emf.ecore.util;

import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.util.AbstractSequentialInternalEList;
import org.eclipse.emf.ecore.util.InternalEList;

public class EContentsEList<E> extends AbstractSequentialInternalEList<E> implements org.eclipse.emf.common.util.EList<E>, org.eclipse.emf.ecore.util.InternalEList<E>
{
    protected EContentsEList() {}
    protected boolean isIncluded(EStructuralFeature p0){ return false; }
    protected boolean isIncludedEntry(EStructuralFeature p0){ return false; }
    protected boolean resolve(){ return false; }
    protected boolean useIsSet(){ return false; }
    protected final EObject eObject = null;
    protected final EStructuralFeature[] eStructuralFeatures = null;
    protected java.util.Iterator<E> newIterator(){ return null; }
    protected java.util.ListIterator<E> newListIterator(){ return null; }
    protected java.util.ListIterator<E> newNonResolvingListIterator(){ return null; }
    protected java.util.ListIterator<E> newResolvingListIterator(){ return null; }
    public E basicGet(int p0){ return null; }
    public E move(int p0, int p1){ return null; }
    public EContentsEList(EObject p0){}
    public EContentsEList(EObject p0, EStructuralFeature[] p1){}
    public EContentsEList(EObject p0, List<? extends EStructuralFeature> p1){}
    public boolean isEmpty(){ return false; }
    public int size(){ return 0; }
    public java.util.Iterator<E> basicIterator(){ return null; }
    public java.util.Iterator<E> iterator(){ return null; }
    public java.util.List<E> basicList(){ return null; }
    public java.util.ListIterator<E> basicListIterator(){ return null; }
    public java.util.ListIterator<E> basicListIterator(int p0){ return null; }
    public java.util.ListIterator<E> listIterator(int p0){ return null; }
    public static <T> org.eclipse.emf.ecore.util.EContentsEList<T> createEContentsEList(EObject p0){ return null; }
    public static <T> org.eclipse.emf.ecore.util.EContentsEList<T> emptyContentsEList(){ return null; }
    public static EContentsEList<? extends Object> EMPTY_CONTENTS_ELIST = null;
    public void move(int p0, Object p1){}
    static public interface FeatureIterator<E> extends java.util.Iterator<E>
    {
        EStructuralFeature feature();
    }
    static public interface FeatureListIterator<E> extends EContentsEList.FeatureIterator<E>, java.util.ListIterator<E>
    {
    }
}
