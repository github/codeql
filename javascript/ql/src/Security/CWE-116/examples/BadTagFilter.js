function filterScript(html) {
    var scriptRegex = /<script\b[^>]*>([\s\S]*?)<\/script>/gi;
    var match;
    while ((match = scriptRegex.exec(html)) !== null) {
        html = html.replace(match[0], match[1]);
    }
    return html;
}
