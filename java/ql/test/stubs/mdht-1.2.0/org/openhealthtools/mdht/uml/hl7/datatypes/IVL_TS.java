// Generated automatically from org.openhealthtools.mdht.uml.hl7.datatypes.IVL_TS for testing purposes

package org.openhealthtools.mdht.uml.hl7.datatypes;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.openhealthtools.mdht.uml.hl7.datatypes.IVXB_TS;
import org.openhealthtools.mdht.uml.hl7.datatypes.PQ;
import org.openhealthtools.mdht.uml.hl7.datatypes.SXCM_TS;
import org.openhealthtools.mdht.uml.hl7.datatypes.TS;

public interface IVL_TS extends SXCM_TS
{
    IVXB_TS getHigh();
    IVXB_TS getLow();
    PQ getWidth();
    TS getCenter();
    boolean validateOptionsContainingCenter(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateOptionsContainingHigh(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateOptionsContainingLow(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateOptionsContainingWidth(DiagnosticChain p0, Map<Object, Object> p1);
    void setCenter(TS p0);
    void setHigh(IVXB_TS p0);
    void setLow(IVXB_TS p0);
    void setWidth(PQ p0);
}
