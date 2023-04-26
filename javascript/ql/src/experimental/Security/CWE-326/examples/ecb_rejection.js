const forge = require("node-forge");

function threeDesECBEncrypt (key, secretText) {

    var threeDesEcbCipher = forge.cipher.createCipher('3DES-ECB', forge.util.createBuffer(key));
    threeDesEcbCipher.start({iv: ''});
    threeDesEcbCipher.update(forge.util.createBuffer(secretText, 'utf-8'));
    threeDesEcbCipher.finish();
    let threeDesEcbEncrypted = threeDesEcbCipher.output;

    console.log(forge.util.encode64(threeDesEcbEncrypted.getBytes()));
}

function threeDesCBCEncrypt (key, secretText) {

    var threeDesCbcCipher = forge.cipher.createCipher('3DES-CBC', forge.util.createBuffer(key));
    threeDesCbcCipher.start({iv: iv});
    threeDesCbcCipher.update(forge.util.createBuffer(secretText, 'utf-8'));
    threeDesCbcCipher.finish();
    let threeDesCbcEncrypted = threeDesCbcCipher.output;

    console.log(forge.util.encode64(threeDesCbcEncrypted.getBytes()));
}


var text = 'secret';
var key = forge.random.getBytesSync(24);

var encryptedEcb = threeDesECBEncrypt(key , text);
var encryptedCbc = threeDesCBCEncrypt(key , text);
