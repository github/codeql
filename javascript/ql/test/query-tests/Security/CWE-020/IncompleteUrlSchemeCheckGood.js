function sanitizeUrl(url) {
    let u = decodeURI(url).trim().toLowerCase();
    if (u.startsWith("javascript:") || u.startsWith("data:") || u.startsWith("vbscript:"))
        return "about:blank";
    return url;
}
