filters = [
    /<script.*?>.*?<\/script>/i, # NOT OK - doesn't match newlines or `</script >`
    /<script.*?>.*?<\/script>/im, # NOT OK - doesn't match `</script >`
    /<script.*?>.*?<\/script[^>]*>/im, # OK
    /<!--.*-->/im, # OK - we don't care regexps that only match comments
    /<!--.*--!?>/im, # OK
    /<!--.*--!?>/i, # NOT OK, does not match newlines
    /<script.*?>(.|\s)*?<\/script[^>]*>/i, # NOT OK - doesn't match inside the script tag
    /<script[^>]*?>.*?<\/script[^>]*>/i, # NOT OK - doesn't match newlines inside the content
    /<script(\s|\w|=|")*?>.*?<\/script[^>]*>/im, # NOT OK - does not match single quotes for attribute values
    /<script(\s|\w|=|')*?>.*?<\/script[^>]*>/im, # NOT OK - does not match double quotes for attribute values
    /<script( |\n|\w|=|'|")*?>.*?<\/script[^>]*>/im, # NOT OK - does not match tabs between attributes
    /<script.*?>.*?<\/script[^>]*>/m, # NOT OK - does not match uppercase SCRIPT tags
    /<(script|SCRIPT).*?>.*?<\/(script|SCRIPT)[^>]*>/m, # NOT OK - does not match mixed case script tags
    /<script[^>]*?>[\s\S]*?<\/script.*>/i, # NOT OK - doesn't match newlines in the end tag
    /<script[^>]*?>[\s\S]*?<\/script[^>]*?>/i, # OK
    /<script\b[^>]*>([\s\S]*?)<\/script>/gi, # NOT OK - too strict matching on the end tag
    /<(?:!--([\S|\s]*?)-->)|([^\/\s>]+)[\S\s]*?>/, # NOT OK - doesn't match comments with the right capture groups
    /<(?:(?:\/([^>]+)>)|(?:!--([\S|\s]*?)-->)|(?:([^\/\s>]+)((?:\s+[\w\-:.]+(?:\s*=\s*?(?:(?:"[^"]*")|(?:'[^']*')|[^\s"'\/>]+))?)*)[\S\s]*?(\/?)>))/, # NOT OK - capture groups
]

doFilters(filters)