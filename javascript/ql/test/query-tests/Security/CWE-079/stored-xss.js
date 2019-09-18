(function() {
    sessionStorage.setItem('session', document.location.search);
    localStorage.setItem('local', document.location.search);

    $('myId').html(sessionStorage.getItem('session')); // NOT OK
    $('myId').html(localStorage.getItem('session')); // OK
    $('myId').html(sessionStorage.getItem('local')); // OK
    $('myId').html(localStorage.getItem('local')); // NOT OK
});
