(function() {
  var translate = {
    "own goal": "backpass",
    "fumble": "feint"
  };
  var target = document.location.search // $ Source
  var searchParams = new URLSearchParams(target.substring(1));
  $('original-term').html(searchParams.get('term')); // $ Alert

  $('translated-term').html(translate[searchParams.get('term')]);
})();
