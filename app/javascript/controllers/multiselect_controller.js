// app/javascript/controllers/multiselect_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    document.addEventListener('turbo:load', () => {
      console.log("Initialisation du multiselect...");

      // Multiselect pour le filtre des langues
      $('#languages-select').multiselect('destroy').multiselect({
        buttonClass: 'form-select',
        templates: {
          button: '<button type="button" class="multiselect dropdown-toggle" data-bs-toggle="dropdown"><span class="multiselect-selected-text"></span></button>',
        },
        includeSelectAllOption: true,
        nonSelectedText: 'Select languages',
        allSelectedText: 'All languages selected',
        nSelectedText: 'languages selected',
        numberDisplayed: 3,
        buttonWidth: '100%',
        maxHeight: 300
      });

      // Multiselect pour le filtre des nationalités des au pairs
      $('#aupair-nationalities-select').multiselect('destroy').multiselect({
        buttonClass: 'form-select',
        templates: {
          button: '<button type="button" class="multiselect dropdown-toggle" data-bs-toggle="dropdown"><span class="multiselect-selected-text"></span></button>',
        },
        includeSelectAllOption: true,
        nonSelectedText: 'Select nationalities',
        allSelectedText: 'All nationalities selected',
        nSelectedText: 'nationalities selected',
        numberDisplayed: 3,
        buttonWidth: '100%',
        maxHeight: 300
      });

      // Multiselect pour le filtre des nationalités des familles
      $('#family-nationalities-select').multiselect('destroy').multiselect({
        buttonClass: 'form-select',
        templates: {
          button: '<button type="button" class="multiselect dropdown-toggle" data-bs-toggle="dropdown"><span class="multiselect-selected-text"></span></button>',
        },
        includeSelectAllOption: true,
        nonSelectedText: 'Select family nationalities',
        allSelectedText: 'All family nationalities selected',
        nSelectedText: 'family nationalities selected',
        numberDisplayed: 3,
        buttonWidth: '100%',
        maxHeight: 300
      });

      console.log("Multiselect initialisé avec succès !");
    });
  }
}
