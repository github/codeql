// Generated automatically from org.openhealthtools.mdht.uml.hl7.datatypes.IVL_PQ for testing purposes

package org.openhealthtools.mdht.uml.hl7.datatypes;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.openhealthtools.mdht.uml.hl7.datatypes.IVXB_PQ;
import org.openhealthtools.mdht.uml.hl7.datatypes.PQ;
import org.openhealthtools.mdht.uml.hl7.datatypes.SXCM_PQ;

public interface IVL_PQ extends SXCM_PQ
{
    IVXB_PQ getHigh();
    IVXB_PQ getLow();
    PQ getCenter();
    PQ getWidth();
    boolean validateOptionsContainingCenter(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateOptionsContainingHigh(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateOptionsContainingLow(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateOptionsContainingWidth(DiagnosticChain p0, Map<Object, Object> p1);
    void setCenter(PQ p0);
    void setHigh(IVXB_PQ p0);
    void setLow(IVXB_PQ p0);
    void setWidth(PQ p0);
}
