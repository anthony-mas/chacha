import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  // 1. OPEN: Finds the modal by CSS selector passed in data-modal-target and adds the active class
  open(event) {
    event.preventDefault();

    // Reads the value from the data-modal-target attribute on the button/link (e.g., "#manage-guests-modal")
    const targetSelector = event.currentTarget.dataset.modalTarget;

    const targetModal = document.querySelector(targetSelector);
    if (targetModal) {
        // 'share-modal-active' is the SCSS class that triggers visibility and animation
        targetModal.classList.add("share-modal-active");
    }
  }

  // 2. CLOSE: Closes a specific modal (used by close buttons and the back button)
  close(event) {
    // Finds the ID of the modal to close (either from the button or by finding the closest parent modal element)
    const targetId = event.currentTarget.dataset.modalTarget;

    if (targetId) {
        const targetModal = document.querySelector(targetId);
        if (targetModal) {
            targetModal.classList.remove("share-modal-active");
        }
    }

    if (event) { event.preventDefault(); }
  }

  // 3. CLOSE BACKDROP: Closes the modal when the user clicks the backdrop area
  closeBackground(event) {
    // If the click target is NOT one of the modal content containers, close the currently active backdrop
    if (!event.target.closest('.share-modal-content') && !event.target.closest('.manage-guests-modal-content')) {
        const activeModal = document.querySelector('.share-modal-active');
        if (activeModal) {
            activeModal.classList.remove('share-modal-active');
        }
    }
  }
}
