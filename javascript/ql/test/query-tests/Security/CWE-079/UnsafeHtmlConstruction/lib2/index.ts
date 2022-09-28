export function trivialXss(s: string) {
    const html = "<span>" + s + "</span>"; // NOT OK - this file is recognized as a main file.
    document.querySelector("#html").innerHTML = html;
}