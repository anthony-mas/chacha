import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["startsOn", "endsOn"]

  connect() {
    console.log("Event form controller connected")
    if (!this.startsOnTarget.value && !this.endsOnTarget.value) {
      this.updateEndsOn()
    }
  }

  updateEndsOn() {
    const startValue = this.startsOnTarget.value;
    if (!startValue) {
      this.endsOnTarget.value = "";
      return;
    }

    const startDate = new Date(startValue);

    if (!isNaN(startDate.getTime())) {
      startDate.setHours(startDate.getHours() + 1);

      this.endsOnTarget.value = this._formatDatetimeLocal(startDate);
    }
  }

  _formatDatetimeLocal(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hour = String(date.getHours()).padStart(2, '0');
    const minute = String(date.getMinutes()).padStart(2, '0');

    return `${year}-${month}-${day}T${hour}:${minute}`;
  }
}
