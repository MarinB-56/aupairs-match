import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["role", "numberOfChildren", "availability", "languages"]

  connect() {
    this.toggleFilters()
  }

  filter(event) {
    const form = event.target.closest("form")
    form.requestSubmit()
  }

  toggleFilters() {
    const role = this.roleTarget.value

    if (role === 'family') {
      this.numberOfChildrenTarget.classList.remove('d-none')
      this.availabilityTarget.classList.add('d-none')
      this.languagesTarget.classList.add('d-none')
    } else if (role === 'au_pair') {
      this.numberOfChildrenTarget.classList.add('d-none')
      this.availabilityTarget.classList.remove('d-none')
      this.languagesTarget.classList.remove('d-none')
    } else {
      // Par défaut, cacher tous les filtres
      this.numberOfChildrenTarget.classList.add('d-none')
      this.availabilityTarget.classList.add('d-none')
      this.languagesTarget.classList.add('d-none')
    }
  }
}
