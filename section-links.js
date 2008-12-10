document.addEventListener('DOMContentLoaded', function(event) {
  function f(n) {
    if (n.nodeType == 1 && n.tagName.match(/^H[1-6]$/)) {
      var span = document.createElement('span');
      span.className = 'section-link';
      span.textContent = '\xa0';
      var a = document.createElement('a');
      a.href = '#' + n.parentNode.id;
      a.textContent = '\xb6';
      span.appendChild(a);
      n.appendChild(span);
    } else {
      n = n.firstChild;
      while (n) {
        f(n);
        n = n.nextSibling;
      }
    }
  }
  f(document.getElementById('sections'));
}, false);
