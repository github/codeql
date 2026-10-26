// Generated automatically from org.openhealthtools.mdht.uml.cda.RegionOfInterest for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.Author;
import org.openhealthtools.mdht.uml.cda.ClinicalStatement;
import org.openhealthtools.mdht.uml.cda.EntryRelationship;
import org.openhealthtools.mdht.uml.cda.Informant12;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.Participant2;
import org.openhealthtools.mdht.uml.cda.Performer2;
import org.openhealthtools.mdht.uml.cda.Precondition;
import org.openhealthtools.mdht.uml.cda.Reference;
import org.openhealthtools.mdht.uml.cda.RegionOfInterestValue;
import org.openhealthtools.mdht.uml.cda.Specimen;
import org.openhealthtools.mdht.uml.cda.Subject;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.vocab.ActClass;
import org.openhealthtools.mdht.uml.hl7.vocab.ActMood;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface RegionOfInterest extends ClinicalStatement
{
    ActClass getClassCode();
    ActMood getMoodCode();
    CS getCode();
    EList<Author> getAuthors();
    EList<CS> getRealmCodes();
    EList<EntryRelationship> getEntryRelationships();
    EList<II> getIds();
    EList<II> getTemplateIds();
    EList<Informant12> getInformants();
    EList<Participant2> getParticipants();
    EList<Performer2> getPerformers();
    EList<Precondition> getPreconditions();
    EList<Reference> getReferences();
    EList<RegionOfInterestValue> getValues();
    EList<Specimen> getSpecimens();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    String getRegionOfInterestId();
    Subject getSubject();
    boolean isSetClassCode();
    boolean isSetMoodCode();
    boolean isSetNullFlavor();
    boolean validateClassCode(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateMoodCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setClassCode(ActClass p0);
    void setCode(CS p0);
    void setMoodCode(ActMood p0);
    void setNullFlavor(NullFlavor p0);
    void setRegionOfInterestId(String p0);
    void setSubject(Subject p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetMoodCode();
    void unsetNullFlavor();
}
