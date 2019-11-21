(function () {
	var foo = new Bloodhound({
	    remote: {
	        url: '/api/destinations/search?text=%QUERY'
	    }
	});
	var bar = new Bloodhound({
	    prefetch: searchIndexUrl
	});
	
	$('.typeahead').typeahead({}, {
        name: 'prefetchedCities',
        source: bar.ttAdapter(),
        templates: {
            suggestion: function (taintedParam) {
	
			},
        }
    });
})();