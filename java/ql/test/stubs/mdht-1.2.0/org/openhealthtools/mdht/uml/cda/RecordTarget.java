// Generated automatically from org.openhealthtools.mdht.uml.cda.RecordTarget for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.PatientRole;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.rim.Participation;
import org.openhealthtools.mdht.uml.hl7.vocab.ContextControl;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.ParticipationType;

public interface RecordTarget extends Participation
{
    ContextControl getContextControlCode();
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    ParticipationType getTypeCode();
    PatientRole getPatientRole();
    boolean isSetContextControlCode();
    boolean isSetNullFlavor();
    boolean isSetTypeCode();
    boolean validateContextControlCode(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateTypeCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setContextControlCode(ContextControl p0);
    void setNullFlavor(NullFlavor p0);
    void setPatientRole(PatientRole p0);
    void setTypeCode(ParticipationType p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetContextControlCode();
    void unsetNullFlavor();
    void unsetTypeCode();
}
