import { Controller } from "@hotwired/stimulus"

// Controls individual post: toggle replies visibility
export default class extends Controller {
  static targets = ["replies"]

  toggleReplies() {
    if (this.hasRepliesTarget) {
      this.repliesTarget.classList.toggle("is-hidden")
      // Focus the reply input when opening
      if (!this.repliesTarget.classList.contains("is-hidden")) {
        const input = this.repliesTarget.querySelector(".reply-input")
        if (input) input.focus()
      }
    }
  }
}
