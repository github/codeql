// Generated automatically from org.eclipse.emf.ecore.EStructuralFeature for testing purposes

package org.eclipse.emf.ecore;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.ETypedElement;

public interface EStructuralFeature extends ETypedElement
{
    Class<? extends Object> getContainerClass();
    EClass getEContainingClass();
    Object getDefaultValue();
    String getDefaultValueLiteral();
    boolean isChangeable();
    boolean isDerived();
    boolean isTransient();
    boolean isUnsettable();
    boolean isVolatile();
    int getFeatureID();
    void setChangeable(boolean p0);
    void setDefaultValue(Object p0);
    void setDefaultValueLiteral(String p0);
    void setDerived(boolean p0);
    void setTransient(boolean p0);
    void setUnsettable(boolean p0);
    void setVolatile(boolean p0);
}
