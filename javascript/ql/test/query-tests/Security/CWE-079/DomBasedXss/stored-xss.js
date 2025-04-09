(function() {
    sessionStorage.setItem('session', document.location.search); // $ Source
    localStorage.setItem('local', document.location.search); // $ Source

    $('myId').html(sessionStorage.getItem('session')); // $ Alert
    $('myId').html(localStorage.getItem('session'));
    $('myId').html(sessionStorage.getItem('local'));
    $('myId').html(localStorage.getItem('local')); // $ Alert

    var href = localStorage.getItem('local');

    $('myId').html("<a href=\"" + href + ">foobar</a>"); // $ Alert

    if (href.indexOf("\"") !== -1) {
        return;
    }
    $('myId').html("<a href=\"" + href + "/>");

    var href2 = localStorage.getItem('local');
    if (href2.indexOf("\"") !== -1) {
        return;
    }
    $('myId').html("\n<a href=\"" + href2 + ">foobar</a>");

    var href3 = localStorage.getItem('local');
    if (href3.indexOf("\"") !== -1) {
        return;
    }
    $('myId').html('\r\n<a href="/' + href3 + '">' + "something" + '</a>');
});
