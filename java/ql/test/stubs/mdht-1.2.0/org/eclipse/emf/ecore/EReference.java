// Generated automatically from org.eclipse.emf.ecore.EReference for testing purposes

package org.eclipse.emf.ecore;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EStructuralFeature;

public interface EReference extends EStructuralFeature
{
    EClass getEReferenceType();
    EList<EAttribute> getEKeys();
    EReference getEOpposite();
    boolean isContainer();
    boolean isContainment();
    boolean isResolveProxies();
    void setContainment(boolean p0);
    void setEOpposite(EReference p0);
    void setResolveProxies(boolean p0);
}
