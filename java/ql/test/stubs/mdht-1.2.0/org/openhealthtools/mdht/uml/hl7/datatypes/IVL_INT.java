// Generated automatically from org.openhealthtools.mdht.uml.hl7.datatypes.IVL_INT for testing purposes

package org.openhealthtools.mdht.uml.hl7.datatypes;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.openhealthtools.mdht.uml.hl7.datatypes.INT;
import org.openhealthtools.mdht.uml.hl7.datatypes.IVXB_INT;
import org.openhealthtools.mdht.uml.hl7.datatypes.SXCM_INT;

public interface IVL_INT extends SXCM_INT
{
    INT getCenter();
    INT getWidth();
    IVXB_INT getHigh();
    IVXB_INT getLow();
    boolean validateOptionsContainingCenter(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateOptionsContainingHigh(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateOptionsContainingLow(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateOptionsContainingWidth(DiagnosticChain p0, Map<Object, Object> p1);
    void setCenter(INT p0);
    void setHigh(IVXB_INT p0);
    void setLow(IVXB_INT p0);
    void setWidth(INT p0);
}
