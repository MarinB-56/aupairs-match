import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="manage-matches"
export default class extends Controller {
  static values = {
    id: Object
  }

  static targets = ["heart"]

  connect() {
    console.log("Matches");
  }

  manage_matches = () => {
    const url = `${document.location.origin}/matches`;

    fetch(url, {
      method: "POST",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({
        initiated_by:  this.idValue.initiated_by,
        received_by: this.idValue.received_by
      })
    })
    .then(response => response.json())
    .then((data) => {
      if (data.status === "deleted") {
        this.heartTarget.classList.remove('icon-match-pending', 'icon-match-accepted', 'icon-match-refused');
        this.heartTarget.classList.add('icon-match-empty');
      }else {
        this.heartTarget.classList.remove('icon-match-empty');
        this.heartTarget.classList.add('icon-match-pending');
      }
    })
  }
}
