addEventListener("message", (event) => {
  angular.merge({}, JSON.parse(event.data)); // $ Alert
});
