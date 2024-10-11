$(document).ready(function() {
  var slider = $("#children_range");
  var valueDisplay = $("#children-value");
  var hiddenInput = $("#max_number_of_children");

  // Initialiser le champ caché avec la valeur actuelle du slider
  hiddenInput.val(slider.val());

  // Mettre à jour la valeur affichée et le champ caché lors du changement du slider
  slider.on("input", function() {
    var currentValue = slider.val();
    valueDisplay.text(currentValue);
    hiddenInput.val(currentValue);
  });
});
