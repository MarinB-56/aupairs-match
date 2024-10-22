// app/javascript/controllers/profile_picture_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["chooseFile", "confirmButton", "currentProfilePhoto", "profileForm"]

  connect() {
    // Assurez-vous que le bouton de confirmation est désactivé par défaut
    this.confirmButtonTarget.disabled = true;

    // Stocker l'URL de l'image actuelle au chargement de la modale
    this.originalImageUrl = this.currentProfilePhotoTarget.src;
  }

  // Détecte le changement d'image
  chooseFileTargetChanged(event) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();

      // Quand le fichier est chargé
      reader.onload = (e) => {
        // Remplacer l'image actuelle (celle avec la classe "current-profile-photo")
        this.currentProfilePhotoTarget.src = e.target.result;

        // Activer le bouton de confirmation
        this.confirmButtonTarget.disabled = false;
      };

      // Lire le fichier
      reader.readAsDataURL(file);
    }
  }

  // Réinitialiser la modale si annulé ou fermé
  resetModal() {
    // Désactiver le bouton de confirmation
    this.confirmButtonTarget.disabled = true;

    // Vider le champ de fichier
    this.chooseFileTarget.value = "";

    // Réafficher l'image d'origine
    this.currentProfilePhotoTarget.src = this.originalImageUrl;
  }

  // Soumettre le formulaire lorsque le bouton "Confirm changes" est cliqué
  submitForm() {
    this.profileFormTarget.submit();
  }
}
