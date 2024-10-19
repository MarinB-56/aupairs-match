import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["chooseFile", "previewImage", "imagePreview", "confirmButton", "cancelButton"];

  connect() {
    this.chooseFileTarget.addEventListener('change', (event) => this.previewImage(event));
  }

  previewImage(event) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        this.previewImageTarget.src = e.target.result;
        this.imagePreviewTarget.style.display = 'block';
        this.confirmButtonTarget.disabled = false;
        this.cancelButtonTarget.textContent = 'Confirm changes';
      };
      reader.readAsDataURL(file);
    }
  }

  resetModal() {
    this.imagePreviewTarget.style.display = 'none';
    this.confirmButtonTarget.disabled = true;
    this.cancelButtonTarget.textContent = 'Cancel';
  }
}
