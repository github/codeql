export function trivialXss(s: string) {
    const html = "<span>" + s + "</span>"; // NOT OK
    document.querySelector("#html").innerHTML = html;
}