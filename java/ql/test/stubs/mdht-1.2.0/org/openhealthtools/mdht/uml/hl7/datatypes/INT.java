// Generated automatically from org.openhealthtools.mdht.uml.hl7.datatypes.INT for testing purposes

package org.openhealthtools.mdht.uml.hl7.datatypes;

import java.math.BigInteger;
import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.openhealthtools.mdht.uml.hl7.datatypes.QTY;

public interface INT extends QTY
{
    BigInteger getValue();
    boolean validateINT(DiagnosticChain p0, Map<Object, Object> p1);
    void setValue(BigInteger p0);
    void setValue(Integer p0);
}
