// Generated automatically from org.openhealthtools.mdht.uml.hl7.datatypes.ST for testing purposes

package org.openhealthtools.mdht.uml.hl7.datatypes;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.openhealthtools.mdht.uml.hl7.datatypes.ED;

public interface ST extends ED
{
    boolean isCompressionDefined();
    boolean isIntegrityCheckAlgorithmDefined();
    boolean isRepresentationDefined();
    boolean validateCompression(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateIntegrityCheck(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateIntegrityCheckAlgorithm(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateReference(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateRepresentation(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateST(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateThumbnail(DiagnosticChain p0, Map<Object, Object> p1);
}
