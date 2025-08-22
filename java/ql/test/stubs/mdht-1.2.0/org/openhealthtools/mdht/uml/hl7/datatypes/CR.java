// Generated automatically from org.openhealthtools.mdht.uml.hl7.datatypes.CR for testing purposes

package org.openhealthtools.mdht.uml.hl7.datatypes;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.openhealthtools.mdht.uml.hl7.datatypes.ANY;
import org.openhealthtools.mdht.uml.hl7.datatypes.CD;
import org.openhealthtools.mdht.uml.hl7.datatypes.CV;

public interface CR extends ANY
{
    CD getValue();
    CV getName();
    boolean isInverted();
    boolean validateCR(DiagnosticChain p0, Map<Object, Object> p1);
    void setInverted(boolean p0);
    void setName(CV p0);
    void setValue(CD p0);
}
