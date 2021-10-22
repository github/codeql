public class MissingSAMLSignatureCheck {
    public void parseResponse(String encodedResponse, PublicKey key) throws Exception {
        byte[] decodedResponse = Base64.getDecoder().decode(encodedResponse);

        Document document = null;
        DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
        documentBuilderFactory.setNamespaceAware(true);
        try {
            DocumentBuilder builder = documentBuilderFactory.newDocumentBuilder();
            document = builder.parse(new ByteArrayInputStream(decodedResponse));
        } catch (Exception e) {
            throw new Exception("Unable to parse SAML v2.0 authentication response", e);
        }

        NodeList nl = document.getElementsByTagNameNS(XMLSignature.XMLNS, "Signature");
        {
            // BAD: skip signature validation if there is no signature node.
            if (nl.getLength() == 0) {
                return;
            }
        }

        { 
            // GOOD: validate all the signature nodes in the XML document
            for (int i = 0; i < nl.getLength(); i++) {
                DOMValidateContext validateContext = new DOMValidateContext(key, nl.item(i));
                XMLSignatureFactory factory = XMLSignatureFactory.getInstance("DOM");
                try {
                    XMLSignature signature = factory.unmarshalXMLSignature(validateContext);
                    boolean valid = signature.validate(validateContext);
                    if (!valid) {
                        throw new Exception("Invalid SAML v2.0 authentication response. The signature is invalid.");
                    }
                } catch (MarshalException e) {
                    throw new Exception("Unable to verify XML signature in the SAML v2.0 authentication response because we couldn't unmarshall the XML Signature element", e);
                } catch (XMLSignatureException e) {
                    throw new Exception("Unable to verify XML signature in the SAML v2.0 authentication response. The signature was unmarshalled we couldn't validate it for an unknown reason", e);
                }
            }
        }

        ResponseType jaxbResponse = unmarshallFromDocument(document, ResponseType.class);
        // Access SAML assertions
        List<Object> assertions = jaxbResponse.getAssertionOrEncryptedAssertion();
    }
}
