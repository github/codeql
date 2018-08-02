angular.module('app').directive('foo', function($location) {
  let redirect = $location.search('redirect');
  // NOT OK
  window.location = redirect;
  // NOT OK
  $location.url(redirect);
  // NOT OK
  window.location = $location.search('redirect') + "foo";
});
