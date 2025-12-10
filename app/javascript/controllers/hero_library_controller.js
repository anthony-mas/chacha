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

    if (event) {
      event.preventDefault()
    }

    this.modalTarget.classList.remove("open")
  }

  // User clicks on a hero image
  choose(event) {
    const filename = event.currentTarget.dataset.image
    const previewUrl = event.currentTarget.dataset.imagePreview

    // Update hidden field with filename only (for backend)
    this.inputTarget.value = filename

    // Update live preview on the form (with full asset URL)
    this.previewTarget.innerHTML = `
      <img src="${previewUrl}" class="hero-image-preview">
    `

    // Close the modal
    this.close()
  }
}
