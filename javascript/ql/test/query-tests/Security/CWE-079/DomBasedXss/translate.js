(function() {
  var translate = {
    "own goal": "backpass",
    "fumble": "feint"
  };
  var target = document.location.search
  var searchParams = new URLSearchParams(target.substring(1));
  // NOT OK
  $('original-term').html(searchParams.get('term'));
  // OK
  $('translated-term').html(translate[searchParams.get('term')]);
})();
