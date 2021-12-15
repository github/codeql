import javascript
private import AngularJS

from NgSourceProvider provider, string src
where provider.providesSourceAt(src, _, _, _, _, _)
select provider, src
