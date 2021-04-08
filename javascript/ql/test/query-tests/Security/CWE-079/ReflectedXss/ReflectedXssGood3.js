var express = require('express');

var app = express();

function escapeHtml1(string) {
  var str = "" + string;
  let escape;
  let html = '';
  let lastIndex = 0;

  for (let index = 0; index < str.length; index++) {
    switch (str.charCodeAt(index)) {
      case 34: // "
        escape = '&quot;';
        break;
      case 38: // &
        escape = '&amp;';
        break;
      case 39: // '
        escape = '&#39;';
        break;
      case 60: // <
        escape = '&lt;';
        break;
      case 62: // >
        escape = '&gt;';
        break;
      default:
        continue;
    }

    if (lastIndex !== index) {
      html += str.substring(lastIndex, index);
    }

    lastIndex = index + 1;
    html += escape;
  }

  return lastIndex !== index
    ? html + str.substring(lastIndex, index)
    : html;
}

function escapeHtml2(s) {
  var buf = "";
  while (i < s.length) {
    var ch = s[i++];
    switch (ch) {
      case '&':
        buf += '&amp;';
        break;
      case '<':
        buf += '&lt;';
        break;
      case '\"':
        buf += '&quot;';
        break;
      default:
        buf += ch;
        break;
    }
  }
  return buf;
}


function escapeHtml3(value) {
  var i = 0;
  var XMLChars = {
    AMP: 38, // "&"
    QUOT: 34, // "\""
    LT: 60, // "<"
    GT: 62, // ">"
  };

  var parts = [value.substring(0, i)];
  while (i < length) {
    switch (ch) {
      case XMLChars.AMP:
        parts.push('&amp;');
        break;
      case XMLChars.QUOT:
        parts.push('&quot;');
        break;
      case XMLChars.LT:
        parts.push('&lt;');
        break;
      case XMLChars.GT:
        parts.push('&gt;');
        break;
    }
    ++i;
    var j = i;
    while (i < length) {
      ch = value.charCodeAt(i);
      if (ch === XMLChars.AMP ||
        ch === XMLChars.QUOT || ch === XMLChars.LT ||
        ch === XMLChars.GT) {
        break;
      }
      i++;
    }
    if (j < i) {
      parts.push(value.substring(j, i));
    }
  }
  return parts.join('');
}


function escapeHtml4(s) {
  var buf = "";
  while (i < s.length) {
    var ch = s.chatAt(i++);
    switch (ch) {
      case '&':
        buf += '&amp;';
        break;
      case '<':
        buf += '&lt;';
        break;
      case '\"':
        buf += '&quot;';
        break;
      default:
        buf += ch;
        break;
    }
  }
  return buf;
}

app.get('/user/:id', function (req, res) {
  const url = req.params.id;

  res.send(escapeHtml1(url)); // OK
  res.send(escapeHtml2(url)); // OK
  res.send(escapeHtml3(url)); // OK - but FP [INCONSISTENCY]
  res.send(escapeHtml4(url)); // OK
});

