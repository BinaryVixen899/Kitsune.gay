window.onload() = function() {
    random
}

function alexischoose() {
const {
    randomInt
} = await import('crypto');
  
  randomInt(3, (err, n) => {
    if (err) throw err;
    console.log(`Random number chosen from (0, 1, 2): ${n}`);
    if (n == 2)  {
       var elem = document.getElementById(laurieplayer)
       elem.removeAttribute(hidden)

    }
  });
}

  