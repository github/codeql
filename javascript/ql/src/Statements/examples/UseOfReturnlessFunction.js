var stage = require("./stage")

function renderText(text, id) {
    document.getElementById(id).innerText = text;
}

var text = renderText("Two households, both alike in dignity", "scene");

stage.show(text);