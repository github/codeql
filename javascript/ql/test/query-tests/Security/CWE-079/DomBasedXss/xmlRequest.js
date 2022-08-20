$(document).ready(function () {
    var xhr = new XMLHttpRequest();
    var url = "{{ some_url }}"
    xhr.open("GET", url, true)
    xhr.setRequestHeader("Content-Type", "application/json")
    xhr.onreadystatechange = function () {
        if (xhr.readyState !== 4) { return }
        var json = JSON.parse(xhr.responseText)
        $("#myThing").html(json.message); // caught with additional sources
    }
    try {
        xhr.send()
    } catch (error) {
        console.log(error)
    }
});

$(document).ready(async function () {
    const got = require('got');
    const resp = await got.get("{{ some_url }}");
    const json = JSON.parse(resp.body);
    $("#myThing").html(json.message); // caught with additional sources

});