// Generated automatically from org.openhealthtools.mdht.uml.hl7.datatypes.URL for testing purposes

package org.openhealthtools.mdht.uml.hl7.datatypes;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.openhealthtools.mdht.uml.hl7.datatypes.ANY;

public interface URL extends ANY
{
    String getValue();
    boolean validateURL(DiagnosticChain p0, Map<Object, Object> p1);
    void setValue(String p0);
}
