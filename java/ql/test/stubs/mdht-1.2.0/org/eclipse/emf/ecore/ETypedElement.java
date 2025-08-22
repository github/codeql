// Generated automatically from org.eclipse.emf.ecore.ETypedElement for testing purposes

package org.eclipse.emf.ecore;

import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EGenericType;
import org.eclipse.emf.ecore.ENamedElement;

public interface ETypedElement extends ENamedElement
{
    EClassifier getEType();
    EGenericType getEGenericType();
    boolean isMany();
    boolean isOrdered();
    boolean isRequired();
    boolean isUnique();
    int getLowerBound();
    int getUpperBound();
    static int UNBOUNDED_MULTIPLICITY = 0;
    static int UNSPECIFIED_MULTIPLICITY = 0;
    void setEGenericType(EGenericType p0);
    void setEType(EClassifier p0);
    void setLowerBound(int p0);
    void setOrdered(boolean p0);
    void setUnique(boolean p0);
    void setUpperBound(int p0);
}
