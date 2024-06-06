// Generated automatically from org.openhealthtools.mdht.uml.cda.Location for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.HealthCareFacility;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.rim.Participation;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.ParticipationTargetLocation;

public interface Location extends Participation
{
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    HealthCareFacility getHealthCareFacility();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    ParticipationTargetLocation getTypeCode();
    boolean isSetNullFlavor();
    boolean isSetTypeCode();
    boolean validateTypeCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setHealthCareFacility(HealthCareFacility p0);
    void setNullFlavor(NullFlavor p0);
    void setTypeCode(ParticipationTargetLocation p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetNullFlavor();
    void unsetTypeCode();
}
