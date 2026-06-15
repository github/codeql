// Generated automatically from org.eclipse.emf.ecore.EObject for testing purposes

package org.eclipse.emf.ecore;

import org.eclipse.emf.common.notify.Notifier;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.TreeIterator;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EOperation;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.resource.Resource;

public interface EObject extends Notifier
{
    EClass eClass();
    EList<EObject> eContents();
    EList<EObject> eCrossReferences();
    EObject eContainer();
    EReference eContainmentFeature();
    EStructuralFeature eContainingFeature();
    Object eGet(EStructuralFeature p0);
    Object eGet(EStructuralFeature p0, boolean p1);
    Object eInvoke(EOperation p0, EList<? extends Object> p1);
    Resource eResource();
    TreeIterator<EObject> eAllContents();
    boolean eIsProxy();
    boolean eIsSet(EStructuralFeature p0);
    void eSet(EStructuralFeature p0, Object p1);
    void eUnset(EStructuralFeature p0);
}
