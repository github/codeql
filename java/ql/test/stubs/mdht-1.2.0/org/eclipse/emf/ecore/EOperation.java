// Generated automatically from org.eclipse.emf.ecore.EOperation for testing purposes

package org.eclipse.emf.ecore;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EGenericType;
import org.eclipse.emf.ecore.EParameter;
import org.eclipse.emf.ecore.ETypeParameter;
import org.eclipse.emf.ecore.ETypedElement;

public interface EOperation extends ETypedElement
{
    EClass getEContainingClass();
    EList<EClassifier> getEExceptions();
    EList<EGenericType> getEGenericExceptions();
    EList<EParameter> getEParameters();
    EList<ETypeParameter> getETypeParameters();
    boolean isOverrideOf(EOperation p0);
    int getOperationID();
}
