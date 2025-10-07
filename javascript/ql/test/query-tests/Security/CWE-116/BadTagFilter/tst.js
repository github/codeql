var filters = [
    /<script.*?>.*?<\/script>/i, // $ Alert - doesn't match newlines or `</script >`
    /<script.*?>.*?<\/script>/is, // $ Alert - doesn't match `</script >`
    /<script.*?>.*?<\/script[^>]*>/is,
    /<!--.*-->/is, // OK - we don't care regexps that only match comments
    /<!--.*--!?>/is,
    /<!--.*--!?>/i, // $ Alert - does not match newlines
    /<script.*?>(.|\s)*?<\/script[^>]*>/i, // $ Alert - doesn't match inside the script tag
    /<script[^>]*?>.*?<\/script[^>]*>/i, // $ Alert - doesn't match newlines inside the content
    /<script(\s|\w|=|")*?>.*?<\/script[^>]*>/is, // $ Alert - does not match single quotes for attribute values
    /<script(\s|\w|=|')*?>.*?<\/script[^>]*>/is, // $ Alert - does not match double quotes for attribute values
    /<script( |\n|\w|=|'|")*?>.*?<\/script[^>]*>/is, // $ Alert - does not match tabs between attributes
    /<script.*?>.*?<\/script[^>]*>/s, // $ Alert - does not match uppercase SCRIPT tags
    /<(script|SCRIPT).*?>.*?<\/(script|SCRIPT)[^>]*>/s, // $ Alert - does not match mixed case script tags
    /<script[^>]*?>[\s\S]*?<\/script.*>/i, // $ Alert - doesn't match newlines in the end tag
    /<script[^>]*?>[\s\S]*?<\/script[^>]*?>/i,
    /<script\b[^>]*>([\s\S]*?)<\/script>/gi, // $ Alert - too strict matching on the end tag
    /<(?:!--([\S|\s]*?)-->)|([^\/\s>]+)[\S\s]*?>/, // $ Alert - doesn't match comments with the right capture groups
    /<(?:(?:\/([^>]+)>)|(?:!--([\S|\s]*?)-->)|(?:([^\/\s>]+)((?:\s+[\w\-:.]+(?:\s*=\s*?(?:(?:"[^"]*")|(?:'[^']*')|[^\s"'\/>]+))?)*)[\S\s]*?(\/?)>))/, // $ Alert - capture groups
	/(<[a-z\/!$]("[^"]*"|'[^']*'|[^'">])*>|<!(--.*?--\s*)+>)/gi, // $ Alert - capture groups
    /<(?:(?:!--([\w\W]*?)-->)|(?:!\[CDATA\[([\w\W]*?)\]\]>)|(?:!DOCTYPE([\w\W]*?)>)|(?:\?([^\s\/<>]+) ?([\w\W]*?)[?/]>)|(?:\/([A-Za-z][A-Za-z0-9\-_\:\.]*)>)|(?:([A-Za-z][A-Za-z0-9\-_\:\.]*)((?:\s+[^"'>]+(?:(?:"[^"]*")|(?:'[^']*')|[^>]*))*|\/|\s+)>))/g, // $ Alert - capture groups
    /<!--([\w\W]*?)-->|<([^>]*?)>/g, // $ Alert - capture groups
]

doFilters(filters)

var strip = '<script([^>]*)>([\\S\\s]*?)<\/script([^>]*)>';  // OK - it's used with the ignorecase flag
new RegExp(strip, 'gi');

var moreFilters = [
    /-->/g, // $ Alert - doesn't match --!>
    /^>|^->|<!--|-->|--!>|<!-$/g,
];

doFilters(moreFilters);