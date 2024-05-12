// Generated automatically from org.eclipse.emf.ecore.xmi.XMLHelper for testing purposes

package org.eclipse.emf.ecore.xmi;

import java.util.List;
import java.util.Map;
import org.eclipse.emf.common.util.EMap;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EDataType;
import org.eclipse.emf.ecore.EFactory;
import org.eclipse.emf.ecore.ENamedElement;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.util.ExtendedMetaData;
import org.eclipse.emf.ecore.xmi.DanglingHREFException;
import org.eclipse.emf.ecore.xmi.NameInfo;
import org.eclipse.emf.ecore.xmi.XMIException;
import org.eclipse.emf.ecore.xmi.XMLResource;

public interface XMLHelper
{
    DanglingHREFException getDanglingHREFException();
    EClassifier getType(EFactory p0, String p1);
    EMap<String, String> getPrefixToNamespaceMap();
    EObject createObject(EFactory p0, EClassifier p1);
    EObject createObject(EFactory p0, String p1);
    EPackage getNoNamespacePackage();
    EPackage[] packages();
    EStructuralFeature getFeature(EClass p0, String p1, String p2);
    EStructuralFeature getFeature(EClass p0, String p1, String p2, boolean p3);
    ExtendedMetaData getExtendedMetaData();
    List<String> getPrefixes(EPackage p0);
    List<XMIException> setManyReference(XMLHelper.ManyReference p0, String p1);
    Map<String, String> getAnyContentPrefixToURIMapping();
    Object getValue(EObject p0, EStructuralFeature p1);
    String convertToString(EFactory p0, EDataType p1, Object p2);
    String getHREF(EObject p0);
    String getID(EObject p0);
    String getIDREF(EObject p0);
    String getJavaEncoding(String p0);
    String getName(ENamedElement p0);
    String getNamespaceURI(String p0);
    String getPrefix(EPackage p0);
    String getPrefix(String p0);
    String getQName(EClass p0);
    String getQName(EDataType p0);
    String getQName(EStructuralFeature p0);
    String getURI(String p0);
    String getXMLEncoding(String p0);
    URI deresolve(URI p0);
    URI resolve(URI p0, URI p1);
    XMLResource getResource();
    XMLResource.XMLMap getXMLMap();
    int getFeatureKind(EStructuralFeature p0);
    static int DATATYPE_IS_MANY = 0;
    static int DATATYPE_SINGLE = 0;
    static int IS_MANY_ADD = 0;
    static int IS_MANY_MOVE = 0;
    static int OTHER = 0;
    static public interface ManyReference
    {
        EObject getObject();
        EStructuralFeature getFeature();
        Object[] getValues();
        int getColumnNumber();
        int getLineNumber();
        int[] getPositions();
    }
    void addPrefix(String p0, String p1);
    void popContext();
    void popContext(Map<String, EFactory> p0);
    void populateNameInfo(NameInfo p0, EClass p1);
    void populateNameInfo(NameInfo p0, EDataType p1);
    void populateNameInfo(NameInfo p0, EStructuralFeature p1);
    void pushContext();
    void recordPrefixToURIMapping();
    void setAnySimpleType(EClass p0);
    void setCheckForDuplicates(boolean p0);
    void setExtendedMetaData(ExtendedMetaData p0);
    void setMustHavePrefix(boolean p0);
    void setNoNamespacePackage(EPackage p0);
    void setOptions(Map<? extends Object, ? extends Object> p0);
    void setPrefixToNamespaceMap(EMap<String, String> p0);
    void setProcessDanglingHREF(String p0);
    void setValue(EObject p0, EStructuralFeature p1, Object p2, int p3);
    void setXMLMap(XMLResource.XMLMap p0);
}
