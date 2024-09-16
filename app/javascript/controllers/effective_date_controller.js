import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dayOfMonthField", "dayOfWeekField", "monthOfYearField", "frequencyFields"]

  connect() {
    // On page load, set up the correct fields based on the existing frequency value
    this.toggleFields()
  }

  // This method handles when the frequency dropdown changes
  setFrequency(event) {
    const selectedFrequency = event.target.value;
    console.log(`Frequency selected: ${selectedFrequency}`);
    
    // Perform any action based on the selected frequency (e.g., setting values)
    // Here, we'll just toggle the fields based on the new selection
    this.toggleFields();
  }

  toggleFields() {
    const frequency = this.element.querySelector('[name="list[payment_schedule_attributes][frequency]"]').value;

    // Show/hide fields based on the selected frequency
    if (frequency === "monthly") {
      this.show(this.dayOfMonthFieldTarget);
      this.hide(this.dayOfWeekFieldTarget);
      this.hide(this.monthOfYearFieldTarget);
    } else if (frequency === "weekly" || frequency === "bi-weekly") {
      this.hide(this.dayOfMonthFieldTarget);
      this.show(this.dayOfWeekFieldTarget);
      this.hide(this.monthOfYearFieldTarget);
    } else if (frequency === "yearly") {
      this.show(this.dayOfMonthFieldTarget);
      this.hide(this.dayOfWeekFieldTarget);
      this.show(this.monthOfYearFieldTarget);
    } else if (frequency === "once") {
      // Hide all recurrence-related fields for one-time payments
      this.hide(this.dayOfMonthFieldTarget);
      this.hide(this.dayOfWeekFieldTarget);
      this.hide(this.monthOfYearFieldTarget);
    } else {
      // Default case: hide all frequency-related fields if frequency is empty
      this.hide(this.dayOfMonthFieldTarget);
      this.hide(this.dayOfWeekFieldTarget);
      this.hide(this.monthOfYearFieldTarget);
    }
  }

  show(target) {
    target.closest(".field").style.display = "block";
  }

  hide(target) {
    target.closest(".field").style.display = "none";
  }
}
