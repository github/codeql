angular.module('app').directive('foo', function($location) {
  let redirect = $location.search('redirect'); // $ Source
  window.location = redirect; // $ Alert
  $location.url(redirect); // $ Alert
  window.location = $location.search('redirect') + "foo"; // $ Alert
});
