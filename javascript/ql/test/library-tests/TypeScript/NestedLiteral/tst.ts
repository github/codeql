interface T {
  name: string;
  children?: T[];
}

let context: T = {
  name: 'x',
  children: [
    { name: 'x1' },
    {
      name: 'x2',
      children: [
        { name: 'x3' }
      ]
    }
  ]
}

let nocontext = {
  name: 'x',
  children: [
    { name: 'x1' },
    {
      name: 'x2',
      children: [
        { name: 'x3' }
      ]
    }
  ]
}
