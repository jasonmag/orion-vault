// app/javascript/controllers/check_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon"]

  toggle() {
    const icon = this.iconTarget
    const isChecked = icon.dataset.checked === "true"

    if (isChecked) {
      // If checked, change to unchecked (empty circle)
      icon.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="h-6 w-6 text-gray-400"><path stroke-linecap="round" stroke-linejoin="round" d="M15 12H9m12 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" /></svg>'
      icon.dataset.checked = "false"
    } else {
      // If unchecked, change to checked (checkmark)
      icon.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg>'
      icon.dataset.checked = "true"
    }
  }
}
