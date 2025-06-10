function reg(){
  const nonIdPattern = 'a-z';
  const basePattern = /[<nonId>]/.source; // $ SPURIOUS:Alert
  const finalPattern = basePattern.replace(/<nonId>/g, nonIdPattern);
  console.log(finalPattern);
  const regex2 = new RegExp(finalPattern);
}

function reg1(){
  const nonIdPattern = 'a-z';
  const reg = /[<nonId>]/; // $ SPURIOUS:Alert
  const basePattern = reg.source;
  const finalPattern = basePattern.replace(/<nonId>/g, nonIdPattern);
  console.log(finalPattern);
  const regex2 = new RegExp(finalPattern);
}

function replacer(reg1, reg2){
  const basePattern = reg1.source;
  const finalPattern = basePattern.replace(/<nonId>/g, reg2);
  return new RegExp(finalPattern);
}
function reg2(){
  const nonIdPattern = 'a-z';
  const reg = /[<nonId>]/; // $ SPURIOUS:Alert
  replacer(reg, nonIdPattern);
}


function replacer3(str, reg2){
  const finalPattern = str.replace(/<nonId>/g, reg2);
  return new RegExp(finalPattern);
}

function replacer2(reg1, reg2){
  const basePattern = reg1.source;
  return replacer3(basePattern, reg2);
}

function reg3(){
  const nonIdPattern = 'a-z';
  const reg = /[<nonId>]/; // $ SPURIOUS:Alert
  replacer2(reg, nonIdPattern);
}
