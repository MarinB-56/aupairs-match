import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submitOnEnter(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault(); // Empêche la création d'une nouvelle ligne
      this.element.requestSubmit(); // Utilise Turbo pour soumettre le formulaire
    }
  }

  connect() {
    console.log("Contrôleur messages connecté");
  }
}
