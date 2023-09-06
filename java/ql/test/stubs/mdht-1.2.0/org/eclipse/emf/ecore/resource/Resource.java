// Generated automatically from org.eclipse.emf.ecore.resource.Resource for testing purposes

package org.eclipse.emf.ecore.resource;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.Map;
import org.eclipse.emf.common.notify.Notifier;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.TreeIterator;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.ResourceSet;

public interface Resource extends Notifier
{
    EList<EObject> getContents();
    EList<Resource.Diagnostic> getErrors();
    EList<Resource.Diagnostic> getWarnings();
    EObject getEObject(String p0);
    ResourceSet getResourceSet();
    String getURIFragment(EObject p0);
    TreeIterator<EObject> getAllContents();
    URI getURI();
    boolean isLoaded();
    boolean isModified();
    boolean isTrackingModification();
    long getTimeStamp();
    static String OPTION_CIPHER = null;
    static String OPTION_SAVE_ONLY_IF_CHANGED = null;
    static String OPTION_SAVE_ONLY_IF_CHANGED_FILE_BUFFER = null;
    static String OPTION_SAVE_ONLY_IF_CHANGED_MEMORY_BUFFER = null;
    static String OPTION_ZIP = null;
    static int RESOURCE__CONTENTS = 0;
    static int RESOURCE__ERRORS = 0;
    static int RESOURCE__IS_LOADED = 0;
    static int RESOURCE__IS_MODIFIED = 0;
    static int RESOURCE__IS_TRACKING_MODIFICATION = 0;
    static int RESOURCE__RESOURCE_SET = 0;
    static int RESOURCE__TIME_STAMP = 0;
    static int RESOURCE__URI = 0;
    static int RESOURCE__WARNINGS = 0;
    static public interface Diagnostic
    {
        String getLocation();
        String getMessage();
        int getColumn();
        int getLine();
    }
    static public interface Factory
    {
        Resource createResource(URI p0);
        static public interface Registry
        {
            Map<String, Object> getContentTypeToFactoryMap();
            Map<String, Object> getExtensionToFactoryMap();
            Map<String, Object> getProtocolToFactoryMap();
            Resource.Factory getFactory(URI p0);
            Resource.Factory getFactory(URI p0, String p1);
            static Resource.Factory.Registry INSTANCE = null;
            static String DEFAULT_CONTENT_TYPE_IDENTIFIER = null;
            static String DEFAULT_EXTENSION = null;
        }
    }
    void delete(Map<? extends Object, ? extends Object> p0);
    void load(InputStream p0, Map<? extends Object, ? extends Object> p1);
    void load(Map<? extends Object, ? extends Object> p0);
    void save(Map<? extends Object, ? extends Object> p0);
    void save(OutputStream p0, Map<? extends Object, ? extends Object> p1);
    void setModified(boolean p0);
    void setTimeStamp(long p0);
    void setTrackingModification(boolean p0);
    void setURI(URI p0);
    void unload();
}
