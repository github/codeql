(function () {
  var autocompleter = new Bloodhound({
    prefetch: remoteUrl
  })
  autocompleter.initialize();
  $('.typeahead').typeahead({}, {
    source: autocompleter.ttAdapter(),
    templates: {
      suggestion: function(loc) {
        return loc; // NOT OK! - but not flagged due to not connecting the Bloodhound source with this sink [INCONSISTENCY]
      }
    }
  })


  $('.typeahead').typeahead({},
    {
      name: 'dashboards',
      source: function (query, cb) {
        var target = document.location.search
        cb(target);
      },
      templates: {
        suggestion: function(val) {
          return val; // NOT OK 
        }
      }
    }
  )	
})