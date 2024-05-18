// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


var minus = document.querySelector(".btn-subtract")
var add = document.querySelector(".btn-add");
var quantityNumber = document.querySelector(".item-quantity");
var currentValue = 1;

if(minus){
  minus.addEventListener("click", function(){
    if(quantityNumber.value === '') { quantityNumber.value = 1; }

    currentValue = parseInt(quantityNumber.value);
    if (currentValue > 1) {
      currentValue -= 1;
      quantityNumber.value = currentValue;
    }
  });
}

if(add){
  add.addEventListener("click", function() {
    if(quantityNumber.value === '') { quantityNumber.value = 0; }

    currentValue = parseInt(quantityNumber.value);
    currentValue += 1;
    quantityNumber.value = currentValue;
  });
}
