// Generated automatically from org.openhealthtools.mdht.uml.hl7.datatypes.RTO_PQ_PQ for testing purposes

package org.openhealthtools.mdht.uml.hl7.datatypes;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.openhealthtools.mdht.uml.hl7.datatypes.PQ;
import org.openhealthtools.mdht.uml.hl7.datatypes.QTY;

public interface RTO_PQ_PQ extends QTY
{
    PQ getDenominator();
    PQ getNumerator();
    boolean validateDenominator(DiagnosticChain p0, Map<Object, Object> p1);
    void setDenominator(PQ p0);
    void setNumerator(PQ p0);
}
