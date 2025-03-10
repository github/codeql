export function trivialXss(s: string) { // $ Source
    const html = "<span>" + s + "</span>"; // $ Alert
    document.querySelector("#html").innerHTML = html;
}