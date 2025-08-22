// Generated automatically from org.openhealthtools.mdht.uml.cda.DocumentRoot for testing purposes

package org.openhealthtools.mdht.uml.cda;

import org.eclipse.emf.common.util.EMap;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.util.FeatureMap;
import org.openhealthtools.mdht.uml.cda.ClinicalDocument;

public interface DocumentRoot extends EObject
{
    ClinicalDocument getClinicalDocument();
    EMap<String, String> getXMLNSPrefixMap();
    EMap<String, String> getXSISchemaLocation();
    FeatureMap getMixed();
    void setClinicalDocument(ClinicalDocument p0);
}
