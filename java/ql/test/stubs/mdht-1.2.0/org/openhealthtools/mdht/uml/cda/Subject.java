// Generated automatically from org.openhealthtools.mdht.uml.cda.Subject for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.RelatedSubject;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.rim.Participation;
import org.openhealthtools.mdht.uml.hl7.vocab.ContextControl;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.ParticipationTargetSubject;

public interface Subject extends Participation
{
    CE getAwarenessCode();
    ContextControl getContextControlCode();
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    ParticipationTargetSubject getTypeCode();
    RelatedSubject getRelatedSubject();
    boolean isSetContextControlCode();
    boolean isSetNullFlavor();
    boolean isSetTypeCode();
    boolean validateContextControlCode(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateTypeCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setAwarenessCode(CE p0);
    void setContextControlCode(ContextControl p0);
    void setNullFlavor(NullFlavor p0);
    void setRelatedSubject(RelatedSubject p0);
    void setTypeCode(ParticipationTargetSubject p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetContextControlCode();
    void unsetNullFlavor();
    void unsetTypeCode();
}
