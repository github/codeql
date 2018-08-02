function* foo(){
  for (var i=0; i<=2; ++i)
    yield i++;
}

(function* bar() {})();
