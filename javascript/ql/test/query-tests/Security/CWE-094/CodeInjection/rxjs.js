var express = require('express');

var app = express();

import { BehaviorSubject } from 'rxjs';


app.get('/some/path', function(req, res) {
  const taint = req.param("wobble");

  const subject = new BehaviorSubject();
  subject.next(taint);
  subject.subscribe({
    next: (v) => {
      eval(v); // NOT OK
    }
  });
  setTimeout(() => {
    eval(subject.value); // NOT OK
  }, 100);
});
