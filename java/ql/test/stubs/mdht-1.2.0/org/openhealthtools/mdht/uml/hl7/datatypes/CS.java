// Generated automatically from org.openhealthtools.mdht.uml.hl7.datatypes.CS for testing purposes

package org.openhealthtools.mdht.uml.hl7.datatypes;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.openhealthtools.mdht.uml.hl7.datatypes.CV;

public interface CS extends CV
{
    boolean validateCodeSystem(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateCodeSystemName(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateCodeSystemVersion(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateDisplayName(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateOriginalText(DiagnosticChain p0, Map<Object, Object> p1);
}
