// Generated automatically from org.openhealthtools.mdht.uml.hl7.datatypes.ADXP for testing purposes

package org.openhealthtools.mdht.uml.hl7.datatypes;

import org.openhealthtools.mdht.uml.hl7.datatypes.ST;
import org.openhealthtools.mdht.uml.hl7.vocab.AddressPartType;

public interface ADXP extends ST
{
    AddressPartType getPartType();
    boolean isSetPartType();
    void setPartType(AddressPartType p0);
    void unsetPartType();
}
