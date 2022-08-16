import java.util.regex.Pattern;

class BadTagTest {
    void test() {
        Pattern.compile("<script.*?>.*?</script>"); // NOT OK - doesn't match newlines or `</script >`
        Pattern.compile("<script.*?>.*?</script>"); // NOT OK - doesn't match `</script >`
        Pattern.compile("<script.*?>.*?</script[^>]*>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL); // OK
        Pattern.compile("<!--.*-->", Pattern.CASE_INSENSITIVE | Pattern.DOTALL); // OK - we don't care regexps that only match comments
        Pattern.compile("<!--.*--!?>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL); // OK
        Pattern.compile("<!--.*--!?>", Pattern.CASE_INSENSITIVE); // NOT OK, does not match newlines
        Pattern.compile("<script.*?>(.|\\s)*?</script[^>]*>", Pattern.CASE_INSENSITIVE); // NOT OK - doesn't match inside the script tag
        Pattern.compile("<script[^>]*?>.*?</script[^>]*>", Pattern.CASE_INSENSITIVE); // NOT OK - doesn't match newlines inside the content
        Pattern.compile("<script(\\s|\\w|=|\")*?>.*?</script[^>]*>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL); // NOT OK - does not match single quotes for attribute values
        Pattern.compile("<script(\\s|\\w|=|')*?>.*?</script[^>]*>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL); // NOT OK - does not match double quotes for attribute values
        Pattern.compile("<script( |\\n|\\w|=|'|\")*?>.*?</script[^>]*>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL); // NOT OK - does not match tabs between attributes
        Pattern.compile("<script.*?>.*?</script[^>]*>", Pattern.CASE_INSENSITIVE); // NOT OK - does not match uppercase SCRIPT tags
        Pattern.compile("<(script|SCRIPT).*?>.*?</(script|SCRIPT)[^>]*>", Pattern.DOTALL); // NOT OK - does not match mixed case script tags
        Pattern.compile("<script[^>]*?>[\\s\\S]*?</script.*>", Pattern.CASE_INSENSITIVE); // NOT OK - doesn't match newlines in the end tag
        Pattern.compile("<script[^>]*?>[\\s\\S]*?</script[^>]*?>", Pattern.CASE_INSENSITIVE); // OK
        Pattern.compile("<(?:!--([\\w\\W]*?)-->)|([^\\s/>]+)[\\S\\s]*?>"); // NOT OK - doesn't match comments with the right capture groups
        Pattern.compile("<(?:(?:/([^>]+)>)|(?:!--([\\w\\W]*?)-->)|(?:([^\\s/>]+)\\s*((?:\\s+[\\w\\-\\.:]+(?:\\s*=\\s*?(?:(?:\"[^\"]*\")|(?:'[^']*')|[^\\s\"'/>]+))?)*)[\\S\\s]*?(/?))>"); // NOT OK - capture groups
        Pattern.compile("(<[a-z/!$](\"[^\"]*\"|'[^']*'|[^'\">])*>|<!(--.*?--\\s*)+>)", Pattern.CASE_INSENSITIVE); // NOT OK - capture groups
        Pattern.compile("<!--([\\w\\W]*?)-->|<([^>]*?)>"); // NOT OK - capture groups
    }
}
