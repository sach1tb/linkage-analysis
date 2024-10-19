function showPrimes(n) {
    nextPrime: for (let i = 2; i < n; i++) {
  
      for (let j = 2; j < i; j++) {
        if (i % j == 0) continue nextPrime;
      }
  
      document.write( i ,); // a prime
    }
  }
  
function moveSlider(elementId) {
    var crank = document.getElementById(elementId);
    var crank_length = document.getElementById("crank_length");
    crank_length.innerHTML = crank.value;

    crank.oninput = function() {
        crank_length.innerHTML = this.value;
    }

    var coupler = document.getElementById("coupler");
    var coupler_length = document.getElementById("coupler_length");
    coupler_length.innerHTML = crank.value;

    coupler.oninput = function() {
        coupler_length.innerHTML = this.value;
    }

    var crank = document.getElementById("crank");
    var crank_length = document.getElementById("crank_length");
    crank_length.innerHTML = crank.value;

    crank.oninput = function() {
        crank_length.innerHTML = this.value;
    }

    var crank = document.getElementById("crank");
    var crank_length = document.getElementById("crank_length");
    crank_length.innerHTML = crank.value;

    crank.oninput = function() {
        crank_length.innerHTML = this.value;
    }
  }

  moveSlider()