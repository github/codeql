# DOM text reinterpreted as HTML (experimental)

Extracting text from a DOM node and interpreting it as HTML can lead to a cross-site scripting vulnerability.

A webpage with this vulnerability reads text from the DOM, and afterwards adds the text as HTML to the DOM. Using text from the DOM as HTML effectively unescapes the text, and thereby invalidates any escaping done on the text. If an attacker is able to control the safe sanitized text, then this vulnerability can be exploited to perform a cross-site scripting attack. 

Note: This CodeQL query is an experimental query. Experimental queries generate alerts using machine learning. They might include more false positives but they will improve over time.

## Recommendation

To guard against cross-site scripting, consider using contextual output encoding/escaping before writing text to the page, or one of the other solutions that are mentioned in the References section below.

## Example

The following example shows a webpage using a `data-target` attribute 
to select and manipulate a DOM element using the JQuery library. In the example, the 
`data-target` attribute is read into the `target` variable, and the 
`$` function is then supposed to use the `target` variable as a CSS 
selector to determine which element should be manipulated.

```javascript
$("button").click(function () {
    var target = $(this).attr("data-target");
    $(target).hide();
});
```

However, if an attacker can control the `data-target` attribute, 
then the value of `target` can be used to cause the `$` function
to execute arbitrary JavaScript. 

The above vulnerability can be fixed by using `$.find` instead of `$`. 
The `$.find` function will only interpret `target` as a CSS selector 
and never as HTML, thereby preventing an XSS attack. 

```javascript
$("button").click(function () {
    var target = $(this).attr("data-target");
	$.find(target).hide();
});
```

## References
* OWASP: [DOM based XSS Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/DOM_based_XSS_Prevention_Cheat_Sheet.html)
* OWASP: [(Cross Site Scripting) Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html)
* OWASP [DOM Based XSS](https://owasp.org/www-community/attacks/DOM_Based_XSS)
* OWASP [Types of Cross-Site Scripting](https://owasp.org/www-community/Types_of_Cross-Site_Scripting)
* Wikipedia: [Cross-site scripting](http://en.wikipedia.org/wiki/Cross-site_scripting)
