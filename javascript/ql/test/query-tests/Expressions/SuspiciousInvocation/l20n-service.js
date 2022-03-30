(function () {
  'use strict';

  class Context {
  }

  class Env {
    createContext(langs, resIds) {
      const ctx = new Context(this, langs, resIds);
    }
  }

  class Remote {
    constructor(fetchResource) {
      new Env(fetchResource);
    }
  }

}());