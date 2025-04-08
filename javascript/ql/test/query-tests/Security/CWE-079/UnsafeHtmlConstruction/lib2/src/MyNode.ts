export function trivialXss(s: string) { // $ Source
    const html = "<span>" + s + "</span>"; // $ Alert - this file is not recognized as a main file.
    document.querySelector("#html").innerHTML = html;
}