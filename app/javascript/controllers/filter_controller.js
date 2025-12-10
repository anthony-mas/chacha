import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { param: String, selected: String }

  toggle(event) {
    event.preventDefault()

    const clickedValue = this.paramValue
    const currentValue = this.selectedValue

    // If clicking the same filter → remove it
    let newValue = clickedValue === currentValue ? "" : clickedValue

    // Build new URL
    const url = new URL(window.location.href)

    if (newValue === "") {
      url.searchParams.delete("filter")
    } else {
      url.searchParams.set("filter", newValue)
    }

    // Reload with new parameters
    window.location.href = url.toString()
  }
}
