// Generated automatically from org.eclipse.emf.ecore.xmi.XMLResource for testing purposes

package org.eclipse.emf.ecore.xmi;

import java.io.Writer;
import java.util.List;
import java.util.Map;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.ENamedElement;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.xmi.DOMHandler;
import org.eclipse.emf.ecore.xmi.DOMHelper;
import org.eclipse.emf.ecore.xml.type.AnyType;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;

public interface XMLResource extends Resource
{
    DOMHelper getDOMHelper();
    Document save(Document p0, Map<? extends Object, ? extends Object> p1, DOMHandler p2);
    Map<EObject, AnyType> getEObjectToExtensionMap();
    Map<EObject, String> getEObjectToIDMap();
    Map<Object, Object> getDefaultLoadOptions();
    Map<Object, Object> getDefaultSaveOptions();
    Map<String, EObject> getIDToEObjectMap();
    String getEncoding();
    String getID(EObject p0);
    String getPublicId();
    String getSystemId();
    String getXMLVersion();
    boolean useZip();
    static String HREF = null;
    static String NIL = null;
    static String NO_NAMESPACE_SCHEMA_LOCATION = null;
    static String OPTION_ANY_SIMPLE_TYPE = null;
    static String OPTION_ANY_TYPE = null;
    static String OPTION_BINARY = null;
    static String OPTION_CONFIGURATION_CACHE = null;
    static String OPTION_DECLARE_XML = null;
    static String OPTION_DEFER_ATTACHMENT = null;
    static String OPTION_DEFER_IDREF_RESOLUTION = null;
    static String OPTION_DISABLE_NOTIFY = null;
    static String OPTION_DOM_USE_NAMESPACES_IN_SCOPE = null;
    static String OPTION_ELEMENT_HANDLER = null;
    static String OPTION_ENCODING = null;
    static String OPTION_ESCAPE_USING_CDATA = null;
    static String OPTION_EXTENDED_META_DATA = null;
    static String OPTION_FLUSH_THRESHOLD = null;
    static String OPTION_FORMATTED = null;
    static String OPTION_KEEP_DEFAULT_CONTENT = null;
    static String OPTION_LAX_FEATURE_PROCESSING = null;
    static String OPTION_LAX_WILDCARD_PROCESSING = null;
    static String OPTION_LINE_WIDTH = null;
    static String OPTION_PARSER_FEATURES = null;
    static String OPTION_PARSER_PROPERTIES = null;
    static String OPTION_PROCESS_DANGLING_HREF = null;
    static String OPTION_PROCESS_DANGLING_HREF_DISCARD = null;
    static String OPTION_PROCESS_DANGLING_HREF_RECORD = null;
    static String OPTION_PROCESS_DANGLING_HREF_THROW = null;
    static String OPTION_PROXY_ATTRIBUTES = null;
    static String OPTION_RECORD_ANY_TYPE_NAMESPACE_DECLARATIONS = null;
    static String OPTION_RECORD_UNKNOWN_FEATURE = null;
    static String OPTION_RESOURCE_ENTITY_HANDLER = null;
    static String OPTION_RESOURCE_HANDLER = null;
    static String OPTION_ROOT_OBJECTS = null;
    static String OPTION_SAVE_DOCTYPE = null;
    static String OPTION_SAVE_TYPE_INFORMATION = null;
    static String OPTION_SCHEMA_LOCATION = null;
    static String OPTION_SCHEMA_LOCATION_IMPLEMENTATION = null;
    static String OPTION_SKIP_ESCAPE = null;
    static String OPTION_SKIP_ESCAPE_URI = null;
    static String OPTION_SUPPRESS_DOCUMENT_ROOT = null;
    static String OPTION_URI_HANDLER = null;
    static String OPTION_USE_CACHED_LOOKUP_TABLE = null;
    static String OPTION_USE_DEPRECATED_METHODS = null;
    static String OPTION_USE_ENCODED_ATTRIBUTE_STYLE = null;
    static String OPTION_USE_FILE_BUFFER = null;
    static String OPTION_USE_LEXICAL_HANDLER = null;
    static String OPTION_USE_PARSER_POOL = null;
    static String OPTION_USE_XML_NAME_TO_FEATURE_MAP = null;
    static String OPTION_XML_MAP = null;
    static String OPTION_XML_OPTIONS = null;
    static String OPTION_XML_VERSION = null;
    static String SCHEMA_LOCATION = null;
    static String TYPE = null;
    static String XML_NS = null;
    static String XML_SCHEMA_URI = null;
    static String XSI_NS = null;
    static String XSI_URI = null;
    static public interface XMLInfo
    {
        String getName();
        String getTargetNamespace();
        int getXMLRepresentation();
        static int ATTRIBUTE = 0;
        static int CONTENT = 0;
        static int ELEMENT = 0;
        static int UNSPECIFIED = 0;
        void setName(String p0);
        void setTargetNamespace(String p0);
        void setXMLRepresentation(int p0);
    }
    static public interface XMLMap
    {
        EClassifier getClassifier(String p0, String p1);
        EPackage getNoNamespacePackage();
        EStructuralFeature getFeature(EClass p0, String p1, String p2);
        List<EStructuralFeature> getFeatures(EClass p0);
        String getIDAttributeName();
        XMLResource.XMLInfo getInfo(ENamedElement p0);
        void add(ENamedElement p0, XMLResource.XMLInfo p1);
        void setIDAttributeName(String p0);
        void setNoNamespacePackage(EPackage p0);
    }
    void load(InputSource p0, Map<? extends Object, ? extends Object> p1);
    void load(Node p0, Map<? extends Object, ? extends Object> p1);
    void save(Writer p0, Map<? extends Object, ? extends Object> p1);
    void setDoctypeInfo(String p0, String p1);
    void setEncoding(String p0);
    void setID(EObject p0, String p1);
    void setUseZip(boolean p0);
    void setXMLVersion(String p0);
}
