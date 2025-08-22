// Generated automatically from org.openhealthtools.mdht.uml.cda.Component2 for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.NonXMLBody;
import org.openhealthtools.mdht.uml.cda.StructuredBody;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.rim.ActRelationship;
import org.openhealthtools.mdht.uml.hl7.vocab.ActRelationshipHasComponent;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface Component2 extends ActRelationship
{
    ActRelationshipHasComponent getTypeCode();
    Boolean getContextConductionInd();
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    InfrastructureRootTypeId getTypeId();
    NonXMLBody getNonXMLBody();
    NullFlavor getNullFlavor();
    StructuredBody getStructuredBody();
    boolean isSetContextConductionInd();
    boolean isSetNullFlavor();
    boolean isSetTypeCode();
    boolean validateBodyChoice(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateContextConductionInd(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateTypeCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setContextConductionInd(Boolean p0);
    void setNonXMLBody(NonXMLBody p0);
    void setNullFlavor(NullFlavor p0);
    void setStructuredBody(StructuredBody p0);
    void setTypeCode(ActRelationshipHasComponent p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetContextConductionInd();
    void unsetNullFlavor();
    void unsetTypeCode();
}
