// Generated automatically from org.eclipse.emf.ecore.EClass for testing purposes

package org.eclipse.emf.ecore;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EGenericType;
import org.eclipse.emf.ecore.EOperation;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.EStructuralFeature;

public interface EClass extends EClassifier
{
    EAttribute getEIDAttribute();
    EList<EAttribute> getEAllAttributes();
    EList<EAttribute> getEAttributes();
    EList<EClass> getEAllSuperTypes();
    EList<EClass> getESuperTypes();
    EList<EGenericType> getEAllGenericSuperTypes();
    EList<EGenericType> getEGenericSuperTypes();
    EList<EOperation> getEAllOperations();
    EList<EOperation> getEOperations();
    EList<EReference> getEAllContainments();
    EList<EReference> getEAllReferences();
    EList<EReference> getEReferences();
    EList<EStructuralFeature> getEAllStructuralFeatures();
    EList<EStructuralFeature> getEStructuralFeatures();
    EOperation getEOperation(int p0);
    EOperation getOverride(EOperation p0);
    EStructuralFeature getEStructuralFeature(String p0);
    EStructuralFeature getEStructuralFeature(int p0);
    boolean isAbstract();
    boolean isInterface();
    boolean isSuperTypeOf(EClass p0);
    int getFeatureCount();
    int getFeatureID(EStructuralFeature p0);
    int getOperationCount();
    int getOperationID(EOperation p0);
    void setAbstract(boolean p0);
    void setInterface(boolean p0);
}
