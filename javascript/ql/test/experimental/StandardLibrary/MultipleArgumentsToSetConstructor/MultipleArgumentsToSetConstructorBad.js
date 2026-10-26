const vowels = new Set('a', 'e', 'i', 'o', 'u'); // $ Alert

function isVowel(char) {
  return vowels.has(char.toLowerCase());
}
