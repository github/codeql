final String xmlStr = "<users>" + 
                        "   <user name=\"aaa\" pass=\"pass1\"></user>" + 
                        "   <user name=\"bbb\" pass=\"pass2\"></user>" + 
                        "</users>";
try {
    DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
    domFactory.setNamespaceAware(true);
    DocumentBuilder builder = domFactory.newDocumentBuilder();
    //Document doc = builder.parse("user.xml");
    Document doc = builder.parse(new InputSource(new StringReader(xmlStr)));

    XPathFactory factory = XPathFactory.newInstance();
    XPath xpath = factory.newXPath();

    // Injectable data
    String user = request.getParameter("user");
    String pass = request.getParameter("pass");
    if (user != null && pass != null) {
        boolean isExist = false;

        // Bad expression
        String expression1 = "/users/user[@name='" + user + "' and @pass='" + pass + "']";
        isExist = (boolean)xpath.evaluate(expression1, doc, XPathConstants.BOOLEAN);
        System.out.println(isExist);

        // Bad expression
        XPathExpression expression2 = xpath.compile("/users/user[@name='" + user + "' and @pass='" + pass + "']");
        isExist = (boolean)expression2.evaluate(doc, XPathConstants.BOOLEAN);
        System.out.println(isExist);

        // Bad expression
        StringBuffer sb = new StringBuffer("/users/user[@name=");
        sb.append(user);
        sb.append("' and @pass='");
        sb.append(pass);
        sb.append("']");
        String query = sb.toString();
        XPathExpression expression3 = xpath.compile(query);
        isExist = (boolean)expression3.evaluate(doc, XPathConstants.BOOLEAN);
        System.out.println(isExist);

        // Good expression
        String expression4 = "/users/user[@name=$user and @pass=$pass]";
        xpath.setXPathVariableResolver(v -> {
        switch (v.getLocalPart()) {
            case "user":
                return user;
            case "pass":
                return pass;
            default:
                throw new IllegalArgumentException();
            }
        });
        isExist = (boolean)xpath.evaluate(expression4, doc, XPathConstants.BOOLEAN);
        System.out.println(isExist);


        // Bad Dom4j 
        org.dom4j.io.SAXReader reader = new org.dom4j.io.SAXReader();
        org.dom4j.Document document = reader.read(new InputSource(new StringReader(xmlStr)));
        isExist = document.selectSingleNode("/users/user[@name='" + user + "' and @pass='" + pass + "']") != null;
        // or document.selectNodes
        System.out.println(isExist);

        // Good Dom4j
        org.jaxen.SimpleVariableContext svc = new org.jaxen.SimpleVariableContext();
        svc.setVariableValue("user", user);
        svc.setVariableValue("pass", pass);
        String xpathString = "/users/user[@name=$user and @pass=$pass]";
        org.dom4j.XPath safeXPath = document.createXPath(xpathString);
        safeXPath.setVariableContext(svc);
        isExist = safeXPath.selectSingleNode(document) != null;
        System.out.println(isExist);
    }
} catch (ParserConfigurationException e) {

} catch (SAXException e) {

} catch (XPathExpressionException e) {

} catch (org.dom4j.DocumentException e) {

}