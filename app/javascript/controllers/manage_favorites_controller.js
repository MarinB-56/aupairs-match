import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="manage-favorites"
export default class extends Controller {
  static values =  {
    id: Object
  }

  connect() {
    console.log("Hello from favorite controller");
  }

  /*
  toggle_favorite = () => {
    console.log("toggle favorites");

    console.log(this.idValue.visiting_user);

    // Appel de l'action Create du controller Favorites
    fetch(`${document.location.origin}/favorites`, {
      method: "POST",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        visiting_user: this.idValue.visiting_user,
        visited_user: this.idValue.visited_user
      })
    });
  }
  */
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
    .then(data => console.log(data))
    .catch((error) => {
      console.error('Erreur:', error);
    });
  }
}
