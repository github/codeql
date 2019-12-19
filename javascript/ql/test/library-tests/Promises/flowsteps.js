(async function () {
  function throws(resolve, reject) {
    throw new Error()
  }
  new Promise(throws)
    .catch((e) => console.log(e));

  new Promise(throws)
    .then((val) => console.log(val), (error) => console.log(error));
  
  try {
    await new Promise(throws);
  } catch (e2) {
    console.log(e2);
  }

  new Promise((resolve, reject) => reject(3))
    .catch((e3) => console.log(e3));

  try {
    await new Promise((resolve, reject) => reject(4));
  } catch(e4) {
    console.log(e4);
  }

  new Promise(throws)
    .then(() => {})
    .catch((e5) => console.log(e5));


  new Promise(throws)
    .then(() => {})
    .catch((e6) => console.log(e6))
    .catch((e7) => console.log(e7));

  var foo = await new Promise((resolve, reject) => resolve(8))

  var bar = await new Promise((resolve, reject) => resolve(9)).then((x) => x + 2);

  var p = Promise.resolve(3);
  var baz = await p.then((val) => val * 2);

  var p2 = new Promise((resolve, reject) => {
    if (Math.random() > 0.5) {
	  resolve(13);
    } else {
	  reject(14);
    }
  });
  var quz = await p2.then(val => val * 4).catch(e => e * 3);

  function returnsPromise() {
    return Promise.resolve(3);
  }
  var a = await returnsPromise();
})();