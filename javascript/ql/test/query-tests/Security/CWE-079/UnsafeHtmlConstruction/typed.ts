export function basicHtmlConstruction(s: string) { // $ Source
    const html = "<span>" + s + "</span>"; // $ Alert
    document.body.innerHTML = html;
}

export function insertIntoCreatedDocument(s: string) { // $ Source
    const newDoc = document.implementation.createHTMLDocument("");
    newDoc.body.innerHTML = "<span>" + s + "</span>"; // $ SPURIOUS: Alert - inserted into document disconnected from the main DOM.
}

export function id(s: string) {
    return s;
}

export function notVulnerable() {
    const s = id("x");
    const html = "<span>" + s + "</span>";
    document.body.innerHTML = html;
}
 