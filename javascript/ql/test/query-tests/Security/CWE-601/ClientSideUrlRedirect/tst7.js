// NOT OK
new Worker(document.location.search.substring(1));

// NOT OK
$("<script>").attr("src", document.location.search.substring(1));
