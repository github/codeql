(...{length}) => length;
async (...{length}) => length;
function restObject1(...{length}) {}
async function restObject2(...{length}) {}
function* restObject3(...{length}) {}
async function* restObject4(...{length}) {}
({ method(...{length}) {} });
class RestObject { constructor(...{length}) {} }
(...{0: x = 1, ...rest}) => x;
async (...{0: x = 1, ...rest}) => x;

(...[first, ...{length}]) => length;
async (...[first, ...{length}]) => length;
([first, ...{length}]) => length;
{
  const [first, ...{length}] = items;
}
([first, ...{length}] = items);
for (const [first, ...{length}] of items) {}
try {} catch ([first, ...{length}]) {}
([...{x: obj.x}] = items);

([...(obj.x)] = items);
([...(x)] = items);
([...obj.x] = items);
({...(obj.rest)} = obj);

{
  const {x, ...rest} = obj;
}
({x, ...obj.rest} = obj);
({ ...obj, });
({ ...obj, x: 1 });
({ ...a, ...b });

{
  const {x = {...obj, y: 1}, ...rest} = input;
}
({x = {...obj, y: 1}, ...rest}) => x;
async ({x = {...obj, y: 1}, ...rest}) => x;
([x = (value), ...rest] = []) => x;
async ({x = (value), ...rest} = {}) => x;
([{...obj, x: 1}.x] = items);
([...({...obj, x: 1}).x] = items);
({[{...obj, x: 1}.x]: value, ...rest} = input);
consume({...obj, x: 1});

[...xs, x = 1];
consume(...xs, x = 1);
async (...xs, x = 1);
({...rest, x: value = 1});
({x = 1, y: value = 0} = input);
({x = 1, y: value = 0}) => x;
([{...rest,}.x, value = 1] = items);

1 + {...obj,};
!{...obj,};
({...obj,} ? x : y);
({...obj,}, x = 1);
for ({...rest,}.x of items) {}

(x) = y;
++(x);
(obj.x)++;

{
  const values = [1, 2, 3];
  function collect(value, index, suffix) {
    return { value, index, suffix };
  }
  values.map(value => [value, (...[index, ...suffix]) => collect(value, index, suffix)]);
}
(...[index, ...suffix]) => index;
async (...[index, ...suffix]) => index;
function restArray(...[index, ...suffix]) {}
([index, ...[suffix]]) => suffix;
(...{length, ...rest}) => length;
async (...{length, ...rest}) => length;