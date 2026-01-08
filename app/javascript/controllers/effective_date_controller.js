import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dayOfMonthField", "dayOfWeekField", "monthOfYearField"]

  connect() {
    // On page load, set up the correct fields based on the existing frequency value
    this.toggleFields()
  }

  // This method handles when the frequency dropdown changes
  setFrequency() {
    // Perform any action based on the selected frequency (e.g., setting values)
    // Here, we'll just toggle the fields based on the new selection
    this.toggleFields();
  }

  toggleFields() {
    const frequency = this.element.querySelector('[name="list[payment_schedule_attributes][frequency]"]').value;

    // Show/hide fields based on the selected frequency
    const requiresDayOfMonth = frequency === "monthly" || frequency === "yearly" || frequency === "semi-monthly";
    const requiresDayOfWeek = frequency === "weekly" || frequency === "bi-weekly";
    const requiresMonthOfYear = frequency === "yearly";

    this.setFieldState(this.dayOfMonthFieldTarget, requiresDayOfMonth);
    this.setFieldState(this.dayOfWeekFieldTarget, requiresDayOfWeek);
    this.setFieldState(this.monthOfYearFieldTarget, requiresMonthOfYear);
    this.setDayOfMonthOptions(frequency);
  }

  setFieldState(target, required) {
    // CSP blocks inline styles in production, so toggle Tailwind's hidden class instead.
    target.classList.toggle("hidden", !required);
    const input = target.querySelector("input, select, textarea");
    if (!input) {
      return;
    }

    input.required = required;
  }

  setDayOfMonthOptions(frequency) {
    const input = this.dayOfMonthFieldTarget.querySelector("select");
    if (!input) {
      return;
    }

    const limitToFirstHalf = frequency === "semi-monthly";
    Array.from(input.options).forEach((option) => {
      if (!option.value) {
        return;
      }

      const day = Number(option.value);
      if (Number.isNaN(day)) {
        return;
      }

      const shouldHide = limitToFirstHalf && day > 15;
      option.disabled = shouldHide;
      option.hidden = shouldHide;
    });

    if (limitToFirstHalf && Number(input.value) > 15) {
      input.value = "";
    }
  }
}
