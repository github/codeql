// Generated automatically from org.eclipse.emf.ecore.EClassifier for testing purposes

package org.eclipse.emf.ecore;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.ENamedElement;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.ETypeParameter;

public interface EClassifier extends ENamedElement
{
    Class<? extends Object> getInstanceClass();
    EList<ETypeParameter> getETypeParameters();
    EPackage getEPackage();
    Object getDefaultValue();
    String getInstanceClassName();
    String getInstanceTypeName();
    boolean isInstance(Object p0);
    int getClassifierID();
    void setInstanceClass(Class<? extends Object> p0);
    void setInstanceClassName(String p0);
    void setInstanceTypeName(String p0);
}
