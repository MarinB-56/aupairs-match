import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="manage-favorites"
export default class extends Controller {
  static values =  {
    id: Object
  }

  static targets = ["star"];

  connect() {
    // console.log(this.starTarget.classList);
  }

  toggle_favorite = () => {
    console.log("toggle favorites");

    // Appel de l'action Create du controller Favorites
    fetch(`${document.location.origin}/favorites`, {
      method: "POST",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({
        visiting_user:  this.idValue.visiting_user,
        visited_user: this.idValue.visited_user
      })
    })
    .then(response => response.json())
    .then((data) => {
      if (data.status === "deleted") {
        this.starTarget.classList.remove("fa-solid");
        this.starTarget.classList.add('fa-regular');
      }else {
        this.starTarget.classList.remove("fa-regular");
        this.starTarget.classList.add('fa-solid');
      }
    })
    .catch((error) => {
      console.error('Erreur:', error);
    });
  }
}
