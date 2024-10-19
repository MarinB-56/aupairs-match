// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Application } from "@hotwired/stimulus"
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

// Bootstrap select
import "bootstrap-select";

document.addEventListener("turbo:load", function() {
  // Initialisation de Bootstrap Select sur tous les éléments <select> avec la classe .selectpicker
  $('.selectpicker').selectpicker();
});

// Initialisation de Stimulus
const application = Application.start()
