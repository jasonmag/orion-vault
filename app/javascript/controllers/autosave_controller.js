import { Controller } from "@hotwired/stimulus"

// Submits the form automatically when inputs change
export default class extends Controller {
  static targets = ["form", "status"]
  static values = { delay: { type: Number, default: 400 } }

  connect() {
    this.submitTimeout = null
  }

  queueSubmit() {
    clearTimeout(this.submitTimeout)
    this.showStatus("Saving…")
    this.submitTimeout = setTimeout(() => this.submit(), this.delayValue)
  }

  submit() {
    if (!this.hasFormTarget) return
    this.formTarget.requestSubmit()
  }

  handleSubmitEnd(event) {
    if (event.detail.success) {
      this.showStatus("Saved")
    } else {
      this.showStatus("Check inputs")
    }
  }

  showStatus(text) {
    if (this.hasStatusTarget) {
      this.statusTarget.textContent = text
    }
  }
}
