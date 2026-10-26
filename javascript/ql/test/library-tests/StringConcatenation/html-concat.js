function f(x, y) {
  let bold = `<b>${x}</b>`;
  let Bold = `<B>${x}</B>`;

  let longTagName = `Hey <strong>${x}</strong>`;

  let longText = `
    Hello ${x}.
    
    <i>Lorem ipsum!</i>`;
  
  let buffer = '';
  buffer += '<li>';
  buffer += x;
  buffer += '!';

  return buffer;
}
