export function trivialXss(s: string) {
    const html = "<span>" + s + "</span>"; // OK - this file is not recognized as a main file.
    document.querySelector("#html").innerHTML = html;
}