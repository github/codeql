// Generated automatically from org.openhealthtools.mdht.uml.cda.util.CDAUtil for testing purposes

package org.openhealthtools.mdht.uml.cda.util;

import java.io.InputStream;
import java.io.OutputStream;
import java.io.Writer;
import java.util.List;
import java.util.Map;
import javax.xml.namespace.QName;
import org.eclipse.emf.common.util.Diagnostic;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.ENamedElement;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.xmi.DOMHandler;
import org.openhealthtools.mdht.emf.runtime.resource.FleXMLResourceSet;
import org.openhealthtools.mdht.emf.runtime.util.Initializer;
import org.openhealthtools.mdht.uml.cda.ClinicalDocument;
import org.openhealthtools.mdht.uml.cda.ClinicalStatement;
import org.openhealthtools.mdht.uml.cda.DocumentRoot;
import org.openhealthtools.mdht.uml.cda.Section;
import org.openhealthtools.mdht.uml.hl7.rim.InfrastructureRoot;
import org.openhealthtools.mdht.uml.hl7.vocab.x_ActRelationshipEntry;
import org.openhealthtools.mdht.uml.hl7.vocab.x_ActRelationshipEntryRelationship;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;

public class CDAUtil
{
    public CDAUtil(){}
    public static <T extends ClinicalStatement> T getClinicalStatement(ClinicalDocument p0, java.lang.Class<T> p1){ return null; }
    public static <T extends ClinicalStatement> T getClinicalStatement(ClinicalDocument p0, java.lang.Class<T> p1, CDAUtil.Filter<T> p2){ return null; }
    public static <T extends ClinicalStatement> java.util.List<T> getClinicalStatements(ClinicalDocument p0, java.lang.Class<T> p1){ return null; }
    public static <T extends ClinicalStatement> java.util.List<T> getClinicalStatements(ClinicalDocument p0, java.lang.Class<T> p1, CDAUtil.Filter<T> p2){ return null; }
    public static <T extends EObject> T getEObject(ClinicalDocument p0, java.lang.Class<T> p1){ return null; }
    public static <T extends EObject> T getEObject(ClinicalDocument p0, java.lang.Class<T> p1, CDAUtil.Filter<T> p2){ return null; }
    public static <T extends EObject> java.util.List<T> getEObjects(ClinicalDocument p0, java.lang.Class<T> p1){ return null; }
    public static <T extends EObject> java.util.List<T> getEObjects(ClinicalDocument p0, java.lang.Class<T> p1, CDAUtil.Filter<T> p2){ return null; }
    public static <T extends Section> T getSection(ClinicalDocument p0, java.lang.Class<T> p1){ return null; }
    public static <T extends Section> T getSection(ClinicalDocument p0, java.lang.Class<T> p1, CDAUtil.Filter<T> p2){ return null; }
    public static <T extends Section> java.util.List<T> getSections(ClinicalDocument p0, java.lang.Class<T> p1){ return null; }
    public static <T extends Section> java.util.List<T> getSections(ClinicalDocument p0, java.lang.Class<T> p1, CDAUtil.Filter<T> p2){ return null; }
    public static <T> T create(EObject p0, String p1){ return null; }
    public static <T> T create(EObject p0, String p1, EClass p2){ return null; }
    public static <T> T get(EObject p0, String p1){ return null; }
    public static CDAUtil.CDAXPath createCDAXPath(ClinicalDocument p0){ return null; }
    public static ClinicalDocument getClinicalDocument(EObject p0){ return null; }
    public static ClinicalDocument load(Document p0){ return null; }
    public static ClinicalDocument load(Document p0, CDAUtil.LoadHandler p1){ return null; }
    public static ClinicalDocument load(Document p0, CDAUtil.ValidationHandler p1){ return null; }
    public static ClinicalDocument load(InputSource p0){ return null; }
    public static ClinicalDocument load(InputSource p0, CDAUtil.LoadHandler p1){ return null; }
    public static ClinicalDocument load(InputSource p0, CDAUtil.ValidationHandler p1){ return null; }
    public static ClinicalDocument load(InputStream p0){ return null; }
    public static ClinicalDocument load(InputStream p0, CDAUtil.LoadHandler p1){ return null; }
    public static ClinicalDocument load(InputStream p0, CDAUtil.ValidationHandler p1){ return null; }
    public static ClinicalDocument load(ResourceSet p0, URI p1, CDAUtil.LoadHandler p2){ return null; }
    public static ClinicalDocument load(ResourceSet p0, URI p1, CDAUtil.ValidationHandler p2){ return null; }
    public static ClinicalDocument load(ResourceSet p0, URI p1, Document p2, CDAUtil.ValidationHandler p3){ return null; }
    public static ClinicalDocument load(ResourceSet p0, URI p1, InputSource p2, CDAUtil.ValidationHandler p3){ return null; }
    public static ClinicalDocument load(ResourceSet p0, URI p1, InputStream p2, CDAUtil.ValidationHandler p3){ return null; }
    public static ClinicalDocument load(URI p0, CDAUtil.ValidationHandler p1){ return null; }
    public static ClinicalDocument loadAs(InputStream p0, EClass p1){ return null; }
    public static ClinicalDocument loadAs(InputStream p0, EClass p1, CDAUtil.ValidationHandler p2){ return null; }
    public static ClinicalStatement resolveReference(ClinicalStatement p0){ return null; }
    public static Document save(ClinicalDocument p0, DOMHandler p1){ return null; }
    public static EClass getDocumentClass(){ return null; }
    public static EList<ClinicalStatement> getEntryRelationshipTargets(ClinicalStatement p0, x_ActRelationshipEntryRelationship p1, EClass p2){ return null; }
    public static EList<ClinicalStatement> getEntryTargets(Section p0, x_ActRelationshipEntry p1, EClass p2){ return null; }
    public static EObject init(EObject p0, Initializer.Registry p1){ return null; }
    public static EObject resolveReference(EObject p0){ return null; }
    public static FleXMLResourceSet createResourceSet(){ return null; }
    public static FleXMLResourceSet createResourceSet(EClass p0){ return null; }
    public static FleXMLResourceSet createResourceSet(String p0){ return null; }
    public static List<ClinicalStatement> getAllClinicalStatements(ClinicalDocument p0){ return null; }
    public static List<EObject> getAllEObjects(ClinicalDocument p0){ return null; }
    public static List<Section> getAllSections(ClinicalDocument p0){ return null; }
    public static List<Section> getAllSections(Section p0){ return null; }
    public static Map<ClinicalDocument, CDAUtil.CDAXPath> CACHE = null;
    public static Map<String, EClass> getAllDocumentClasses(){ return null; }
    public static Object query(EObject p0, String p1){ return null; }
    public static Section getSection(EObject p0){ return null; }
    public static String CDA_ANNOTATION_SOURCE = null;
    public static String getName(ENamedElement p0){ return null; }
    public static String getPath(EObject p0){ return null; }
    public static boolean check(EObject p0, String p1){ return false; }
    public static boolean isReference(EObject p0){ return false; }
    public static boolean isSet(EObject p0, String p1){ return false; }
    public static boolean validate(ClinicalDocument p0){ return false; }
    public static boolean validate(ClinicalDocument p0, CDAUtil.ValidationHandler p1){ return false; }
    public static boolean validate(ClinicalDocument p0, CDAUtil.ValidationHandler p1, boolean p2){ return false; }
    public static void init(EObject p0){}
    public static void init(EObject p0, Map<String, String> p1){}
    public static void loadPackages(){}
    public static void loadPackages(String p0){}
    public static void performEMFValidation(ClinicalDocument p0, CDAUtil.ValidationHandler p1){}
    public static void performEMFValidation(Document p0, CDAUtil.ValidationHandler p1){}
    public static void performSchemaValidation(ClinicalDocument p0, CDAUtil.ValidationHandler p1){}
    public static void performSchemaValidation(Document p0, CDAUtil.ValidationHandler p1){}
    public static void save(ClinicalDocument p0, OutputStream p1){}
    public static void save(ClinicalDocument p0, OutputStream p1, boolean p2){}
    public static void save(ClinicalDocument p0, Writer p1){}
    public static void save(ClinicalDocument p0, Writer p1, boolean p2){}
    public static void saveSnippet(InfrastructureRoot p0, OutputStream p1){}
    public static void saveSnippet(InfrastructureRoot p0, OutputStream p1, boolean p2){}
    public static void saveSnippet(InfrastructureRoot p0, Writer p1){}
    public static void set(EObject p0, String p1, Object p2){}
    public static void setDocumentClass(EClass p0){}
    public static void setDocumentClassQName(String p0){}
    public static void unset(EObject p0, String p1){}
    static public class CDAXPath
    {
        protected CDAXPath() {}
        public <T extends EObject> T selectSingleNode(Object p0, String p1, java.lang.Class<T> p2){ return null; }
        public <T extends EObject> T selectSingleNode(String p0, java.lang.Class<T> p1){ return null; }
        public <T extends EObject> java.util.List<T> selectNodes(Object p0, String p1, java.lang.Class<T> p2){ return null; }
        public <T extends EObject> java.util.List<T> selectNodes(String p0, java.lang.Class<T> p1){ return null; }
        public <T> T evaluate(Object p0, String p1, java.lang.Class<T> p2){ return null; }
        public <T> T evaluate(String p0, java.lang.Class<T> p1){ return null; }
        public CDAXPath(ClinicalDocument p0){}
        public ClinicalDocument getClinicalDocument(){ return null; }
        public Document getDocument(){ return null; }
        public DocumentRoot getDocumentRoot(){ return null; }
        public List<Node> selectNodes(Node p0, String p1){ return null; }
        public List<Node> selectNodes(String p0){ return null; }
        public Node getNode(Object p0){ return null; }
        public Node selectSingleNode(Node p0, String p1){ return null; }
        public Node selectSingleNode(String p0){ return null; }
        public Object evaluate(Node p0, String p1, QName p2){ return null; }
        public Object evaluate(String p0, QName p1){ return null; }
        public Object getObject(Node p0){ return null; }
    }
    static public interface Filter<T>
    {
        boolean accept(T p0);
    }
    static public interface LoadHandler
    {
        boolean handleUnknownFeature(EObject p0, EStructuralFeature p1, Object p2);
    }
    static public interface ValidationHandler
    {
        void handleError(Diagnostic p0);
        void handleInfo(Diagnostic p0);
        void handleWarning(Diagnostic p0);
    }
}
