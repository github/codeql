const vowels = new Set('a', 'e', 'i', 'o', 'u');

function isVowel(char) {
  return vowels.has(char.toLowerCase());
}
