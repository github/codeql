// Generated automatically from org.openhealthtools.mdht.uml.cda.ObservationMedia for testing purposes

package org.openhealthtools.mdht.uml.cda;

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
import org.openhealthtools.mdht.uml.cda.Specimen;
import org.openhealthtools.mdht.uml.cda.Subject;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.ED;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.vocab.ActClassObservation;
import org.openhealthtools.mdht.uml.hl7.vocab.ActMood;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface ObservationMedia extends ClinicalStatement
{
    ActClassObservation getClassCode();
    ActMood getMoodCode();
    CS getLanguageCode();
    ED getValue();
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
    EList<Specimen> getSpecimens();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    String getObservationMediaId();
    Subject getSubject();
    boolean isSetClassCode();
    boolean isSetMoodCode();
    boolean isSetNullFlavor();
    void setClassCode(ActClassObservation p0);
    void setLanguageCode(CS p0);
    void setMoodCode(ActMood p0);
    void setNullFlavor(NullFlavor p0);
    void setObservationMediaId(String p0);
    void setSubject(Subject p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void setValue(ED p0);
    void unsetClassCode();
    void unsetMoodCode();
    void unsetNullFlavor();
}
