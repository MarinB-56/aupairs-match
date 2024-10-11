$(document).ready(function() {
  var minRange = $("#min_children_range");
  var maxRange = $("#max_children_range");

  var minValueDisplay = $("#min-value");
  var maxValueDisplay = $("#max-value");

  var minChildrenInput = $("#min_number_of_children");
  var maxChildrenInput = $("#max_number_of_children");

  // Initialiser les champs cachés avec les valeurs actuelles
  minChildrenInput.val(minRange.val());
  maxChildrenInput.val(maxRange.val());

  // Mettre à jour l'affichage des valeurs et les champs cachés
  minRange.on("input", function() {
    if (parseInt(minRange.val()) > parseInt(maxRange.val())) {
      minRange.val(maxRange.val()); // Empêche min d'être supérieur à max
    }
    minValueDisplay.text(minRange.val());
    minChildrenInput.val(minRange.val());
  });

  maxRange.on("input", function() {
    if (parseInt(maxRange.val()) < parseInt(minRange.val())) {
      maxRange.val(minRange.val()); // Empêche max d'être inférieur à min
    }
    maxValueDisplay.text(maxRange.val());
    maxChildrenInput.val(maxRange.val());
  });
});
