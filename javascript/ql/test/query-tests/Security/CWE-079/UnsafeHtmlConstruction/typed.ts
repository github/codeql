export function basicHtmlConstruction(s: string) {
    const html = "<span>" + s + "</span>"; // NOT OK
    document.body.innerHTML = html;
}

export function insertIntoCreatedDocument(s: string) {
    const newDoc = document.implementation.createHTMLDocument("");
    newDoc.body.innerHTML = "<span>" + s + "</span>"; // OK - inserted into document disconnected from the main DOM. [INCONSISTENCY]
}

export function id(s: string) {
    return s;
}

export function notVulnerable() {
    const s = id("x");
    const html = "<span>" + s + "</span>"; // OK
    document.body.innerHTML = html;
}
 