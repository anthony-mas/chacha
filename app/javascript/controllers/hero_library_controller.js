import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hero-library"
export default class extends Controller {
  static targets = ["modal", "input", "preview"]

  // Show modal
  open() {
    this.modalTarget.classList.add("open")
  }

  // Hide modal
  close(event) {
    event.preventDefault();
    this.modalTarget.classList.remove("open")
  }

  // User clicks on a hero image
  choose(event) {
    const selectedImage = event.currentTarget.dataset.image

    // Update hidden field
    this.inputTarget.value = selectedImage

    // Update live preview on the form
    this.previewTarget.innerHTML = `
      <img src="/assets/hero_library/${selectedImage}.jpg" class="hero-image-preview">
    `

    // Close the modal
    this.close()
  }
}
