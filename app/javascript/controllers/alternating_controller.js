import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["word"];

  connect() {
    this.words = ["Au Pair", "Family"];
    this.currentIndex = 0;
    this.switchWord();
  }

  switchWord() {
    setInterval(() => {
      // Animer la sortie
      this.wordTarget.classList.add('slide-out');

      // Changer le mot après l'animation de sortie (après 0.5s ici)
      setTimeout(() => {
        this.currentIndex = (this.currentIndex + 1) % this.words.length;
        this.wordTarget.textContent = this.words[this.currentIndex];

        // Réinitialiser l'animation pour le nouveau mot
        this.wordTarget.classList.remove('slide-out');
        this.wordTarget.classList.add('slide-in');
      }, 500); // 500ms = durée de l'animation de sortie
    }, 3000); // Change toutes les 3 secondes
  }
}
