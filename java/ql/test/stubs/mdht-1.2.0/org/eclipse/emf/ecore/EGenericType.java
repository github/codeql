// Generated automatically from org.eclipse.emf.ecore.EGenericType for testing purposes

package org.eclipse.emf.ecore;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.ETypeParameter;

public interface EGenericType extends EObject
{
    EClassifier getEClassifier();
    EClassifier getERawType();
    EGenericType getELowerBound();
    EGenericType getEUpperBound();
    EList<EGenericType> getETypeArguments();
    ETypeParameter getETypeParameter();
    void setEClassifier(EClassifier p0);
    void setELowerBound(EGenericType p0);
    void setETypeParameter(ETypeParameter p0);
    void setEUpperBound(EGenericType p0);
}
