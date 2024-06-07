// Generated automatically from org.eclipse.emf.ecore.EFactory for testing purposes

package org.eclipse.emf.ecore;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EDataType;
import org.eclipse.emf.ecore.EModelElement;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;

public interface EFactory extends EModelElement
{
    EObject create(EClass p0);
    EPackage getEPackage();
    Object createFromString(EDataType p0, String p1);
    String convertToString(EDataType p0, Object p1);
    void setEPackage(EPackage p0);
}
