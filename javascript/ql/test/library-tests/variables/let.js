{
    let x = 23;
    {
        let x = 42;
        for (let x = 23, y = x-19; x<y;) {
            let x = 56;
            console.log(x);
        }
        for (let x in { x: x })
            x;
    }
}

function foo(x) {
    switch (x) {
    case 23:
      let y = x;
    case 42:
      y += 19;
    }
}
