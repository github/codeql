// Generated automatically from org.openhealthtools.mdht.uml.hl7.datatypes.II for testing purposes

package org.openhealthtools.mdht.uml.hl7.datatypes;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.openhealthtools.mdht.uml.hl7.datatypes.ANY;

public interface II extends ANY
{
    Boolean getDisplayable();
    String getAssigningAuthorityName();
    String getExtension();
    String getRoot();
    boolean validateII(DiagnosticChain p0, Map<Object, Object> p1);
    void setAssigningAuthorityName(String p0);
    void setDisplayable(Boolean p0);
    void setExtension(String p0);
    void setRoot(String p0);
}
