// Generated automatically from org.openhealthtools.mdht.uml.hl7.datatypes.ENXP for testing purposes

package org.openhealthtools.mdht.uml.hl7.datatypes;

import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.hl7.datatypes.ST;
import org.openhealthtools.mdht.uml.hl7.vocab.EntityNamePartQualifier;
import org.openhealthtools.mdht.uml.hl7.vocab.EntityNamePartType;

public interface ENXP extends ST
{
    EList<EntityNamePartQualifier> getQualifiers();
    EntityNamePartType getPartType();
    boolean isSetPartType();
    boolean isSetQualifiers();
    void setPartType(EntityNamePartType p0);
    void unsetPartType();
    void unsetQualifiers();
}
