({x = 1}) => x;

const example = ({ set = {}, unset = [] }, replacements) => {
  return { set, unset };
};
({ get = {}, set = [] }) => ({ get, set });
async ({ get = 1, set = 2 } = {}) => ({ get, set });

let get, set;
({ get = 1, set = 2 } = {});
function defaults({ get = 1, set = 2 }) {
  return { get, set };
}

({
  get value() { return get; },
  set value(v) { set = v; },
  get,
  set
});
({ get() {}, set(value) {} });