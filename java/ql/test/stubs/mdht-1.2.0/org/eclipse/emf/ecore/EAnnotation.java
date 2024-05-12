// Generated automatically from org.eclipse.emf.ecore.EAnnotation for testing purposes

package org.eclipse.emf.ecore;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.EMap;
import org.eclipse.emf.ecore.EModelElement;
import org.eclipse.emf.ecore.EObject;

public interface EAnnotation extends EModelElement
{
    EList<EObject> getContents();
    EList<EObject> getReferences();
    EMap<String, String> getDetails();
    EModelElement getEModelElement();
    String getSource();
    void setEModelElement(EModelElement p0);
    void setSource(String p0);
}
