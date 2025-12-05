import { Controller } from "@hotwired/stimulus"

// Controls the Activity section: post form toggle and "see all" expansion
export default class extends Controller {
  static targets = ["postForm", "hiddenPost", "seeAllBtn"]

  togglePostForm() {
    if (this.hasPostFormTarget) {
      this.postFormTarget.classList.toggle("is-hidden")
      // Focus the textarea when opening
      if (!this.postFormTarget.classList.contains("is-hidden")) {
        const textarea = this.postFormTarget.querySelector("textarea")
        if (textarea) textarea.focus()
      }
    }
  }

  showAll() {
    // Show all hidden posts
    this.hiddenPostTargets.forEach(post => {
      post.classList.remove("activity-post-hidden")
    })

    // Hide the "See all" button
    if (this.hasSeeAllBtnTarget) {
      this.seeAllBtnTarget.style.display = "none"
    }
  }
}
