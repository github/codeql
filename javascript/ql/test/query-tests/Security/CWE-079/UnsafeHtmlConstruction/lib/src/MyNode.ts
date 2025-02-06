export function trivialXss(s: string) {
    const html = "<span>" + s + "</span>"; // $ Alert
    document.querySelector("#html").innerHTML = html;
}