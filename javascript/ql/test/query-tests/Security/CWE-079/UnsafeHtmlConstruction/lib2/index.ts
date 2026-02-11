export function trivialXss(s: string) { // $ Source
  const html = "<span>" + s + "</span>"; // $ Alert - this file is recognized as a main file.
  document.querySelector("#html").innerHTML = html;
}

export function objectStuff(settings: any, i: number) { // $ Source
  document.querySelector("#html").innerHTML = "<span>" + settings + "</span>"; // $ Alert
  var name;

  if (settings.mySetting && settings.mySetting.length !== 0) {
    for (i = 0; i < settings.mySetting.length; ++i) {
      if (typeof settings.mySetting[i] === "object") {
        name = settings.mySetting[i].name; //  `settings.mySetting[i]` is correctly sanitized, as it is an object. However, the `name` property is stil tainted.
      } else {
        name = "";
      }

      document.querySelector("#html").innerHTML = "<span>" + name + "</span>"; // $ Alert
    }
  }
}
