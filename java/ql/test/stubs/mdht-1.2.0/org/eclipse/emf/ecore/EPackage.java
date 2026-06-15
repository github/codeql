// Generated automatically from org.eclipse.emf.ecore.EPackage for testing purposes

package org.eclipse.emf.ecore;

import java.util.Map;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EFactory;
import org.eclipse.emf.ecore.ENamedElement;

public interface EPackage extends ENamedElement
{
    EClassifier getEClassifier(String p0);
    EFactory getEFactoryInstance();
    EList<EClassifier> getEClassifiers();
    EList<EPackage> getESubpackages();
    EPackage getESuperPackage();
    String getNsPrefix();
    String getNsURI();
    static public interface Registry extends Map<String, Object>
    {
        EFactory getEFactory(String p0);
        EPackage getEPackage(String p0);
        static EPackage.Registry INSTANCE = null;
    }
    void setEFactoryInstance(EFactory p0);
    void setNsPrefix(String p0);
    void setNsURI(String p0);
}
