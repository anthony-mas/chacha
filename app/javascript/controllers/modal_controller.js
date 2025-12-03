import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    this.element.classList.remove("share-modal-active"); // Hide by default
  }

  open() {
    this.element.classList.add("share-modal-active");
  }

  close() {
    this.element.classList.remove("share-modal-active");
  }

  // Closes the modal if the user clicks the gray background area
  closeBackground(event) {
    if (event.target === this.element) {
      this.close();
    }
  }
}
