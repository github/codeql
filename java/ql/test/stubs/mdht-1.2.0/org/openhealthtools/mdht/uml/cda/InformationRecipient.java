// Generated automatically from org.openhealthtools.mdht.uml.cda.InformationRecipient for testing purposes

package org.openhealthtools.mdht.uml.cda;

import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.IntendedRecipient;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.rim.Participation;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.x_InformationRecipient;

public interface InformationRecipient extends Participation
{
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    InfrastructureRootTypeId getTypeId();
    IntendedRecipient getIntendedRecipient();
    NullFlavor getNullFlavor();
    boolean isSetNullFlavor();
    boolean isSetTypeCode();
    void setIntendedRecipient(IntendedRecipient p0);
    void setNullFlavor(NullFlavor p0);
    void setTypeCode(x_InformationRecipient p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetNullFlavor();
    void unsetTypeCode();
    x_InformationRecipient getTypeCode();
}
