// Generated automatically from org.openhealthtools.mdht.emf.runtime.util.Initializer for testing purposes

package org.openhealthtools.mdht.emf.runtime.util;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;

public interface Initializer<T extends EObject>
{
    T initialize(T p0);
    boolean equals(Object p0);
    int hashCode();
    java.lang.Class<? extends T> getTargetType();
    static public interface Factory
    {
        Iterable<? extends Initializer<? extends EObject>> createInitializers(EClass p0);
    }
    static public interface Registry
    {
        <T extends EObject> java.lang.Iterable<? extends org.openhealthtools.mdht.emf.runtime.util.Initializer<? super T>> getInitializers(EClass p0);
        <T extends EObject> java.lang.Iterable<? extends org.openhealthtools.mdht.emf.runtime.util.Initializer<? super T>> getInitializers(EClass p0, boolean p1);
        Initializer.Factory getFactory(String p0);
        Initializer.Registry addAllInitializers(EClass p0, Iterable<? extends Initializer<? extends EObject>> p1);
        Initializer.Registry addInitializer(EClass p0, Initializer<? extends EObject> p1);
        Initializer.Registry initializeEPackage(EPackage p0);
        Initializer.Registry initializeEPackage(EPackage p0, Initializer.Factory p1);
        Initializer.Registry registerFactory(String p0, Initializer.Factory p1);
        static Initializer.Registry INSTANCE = null;
    }
}
