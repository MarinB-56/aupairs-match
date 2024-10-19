import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="manage-matches"
export default class extends Controller {
  static values = {
    id: Object,
    match: Number
  }

  static targets = ["heart", "notification"]

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
        this.heartTarget.classList.remove('fa-heart-circle-xmark', 'fa-heart-circle-exclamation', 'fa-heart-circle-check')
        this.heartTarget.classList.add('icon-match-empty', 'fa-heart-circle-plus');
      }else {
        this.heartTarget.classList.remove('icon-match-empty');
        this.heartTarget.classList.remove('fa-heart-circle-plus')
        this.heartTarget.classList.add('icon-match-pending', 'fa-heart-circle-exclamation');
      }
    })
  }

  accept_or_refuse_match = (event) => {
    const status = event.target.value;
    const url = `${document.location.origin}/matches/${this.matchValue}`;

    console.log(status);
    console.log(url);

    fetch(url, {
      method: "PATCH",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({
        id: this.matchValue,
        status: status
      })
    })
    .then(response => response.json())
    .then((data) => {
      console.log(data.message);

      this.notificationTarget.remove();

    });
  }
}
