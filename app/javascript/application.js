// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Application } from "@hotwired/stimulus"
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"


// Bootstrap select
import "bootstrap-select";

// Script de défilement des messages et channel Actioncable
import './scroll_messages';
import './channels/conversation_channel';

document.addEventListener("turbo:load", function() {
  // Initialisation de Bootstrap Select sur tous les éléments <select> avec la classe .selectpicker
  $('.selectpicker').selectpicker();
});

$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})

// Initialisation de Stimulus
const application = Application.start()

// Initialisation de Rails UJS
import Rails from "@rails/ujs"
Rails.start()
