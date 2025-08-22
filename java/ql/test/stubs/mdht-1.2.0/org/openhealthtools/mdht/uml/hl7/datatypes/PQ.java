// Generated automatically from org.openhealthtools.mdht.uml.hl7.datatypes.PQ for testing purposes

package org.openhealthtools.mdht.uml.hl7.datatypes;

import java.math.BigDecimal;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.hl7.datatypes.PQR;
import org.openhealthtools.mdht.uml.hl7.datatypes.QTY;

public interface PQ extends QTY
{
    BigDecimal getValue();
    EList<PQR> getTranslations();
    String getUnit();
    void setUnit(String p0);
    void setValue(BigDecimal p0);
    void setValue(Double p0);
}
