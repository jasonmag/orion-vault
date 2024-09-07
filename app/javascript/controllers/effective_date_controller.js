// app/javascript/controllers/effective_date_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["startDate", "endDate"]

  connect() {
    this.updateEndDateMin()
  }

  updateStartDate() {
    const startDate = this.startDateTarget.value
    this.endDateTarget.min = startDate

    if (new Date(startDate) > new Date(this.endDateTarget.value)) {
      this.endDateTarget.value = startDate
    }
  }

  updateEndDateMin() {
    const startDate = this.startDateTarget.value
    this.endDateTarget.min = startDate
  }
}
