const execa = require('execa');

(async () => {
  const first = execa('node', ['empty.js']);
  const second = execa('node', ['stdin.js']);

  first.stdout.pipe(second.stdin); // $SPURIOUS:Alert

  const {stdout} = await second;
  console.log(stdout);
})();
