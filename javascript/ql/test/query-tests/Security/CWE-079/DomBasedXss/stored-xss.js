(function() {
    sessionStorage.setItem('session', document.location.search);
    localStorage.setItem('local', document.location.search);

    $('myId').html(sessionStorage.getItem('session')); // NOT OK
    $('myId').html(localStorage.getItem('session')); // OK
    $('myId').html(sessionStorage.getItem('local')); // OK
    $('myId').html(localStorage.getItem('local')); // NOT OK

    var href = localStorage.getItem('local');

    $('myId').html("<a href=\"" + href + ">foobar</a>"); // NOT OK

    if (href.indexOf("\"") !== -1) {
        return;
    }
    $('myId').html("<a href=\"" + href + "/>"); // OK

    var href2 = localStorage.getItem('local');
    if (href2.indexOf("\"") !== -1) {
        return;
    }
    $('myId').html("\n<a href=\"" + href2 + ">foobar</a>"); // OK

    var href3 = localStorage.getItem('local');
    if (href3.indexOf("\"") !== -1) {
        return;
    }
    $('myId').html('\r\n<a href="/' + href3 + '">' + "something" + '</a>'); // OK
});
