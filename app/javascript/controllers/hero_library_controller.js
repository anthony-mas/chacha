import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hero-library"
export default class extends Controller {
  static targets = ["modal", "input"]

  // Open the modal
  open() {
    this.modalTarget.classList.add("open")
  }

  // Close the modal
  close() {
    this.modalTarget.classList.remove("open")
  }

  // Select an image and close modal
  choose(event) {
    const selectedImage = event.currentTarget.dataset.image
    this.inputTarget.value = selectedImage
    this.close()
  }
}
