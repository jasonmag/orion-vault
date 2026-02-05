// app/javascript/controllers/check_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon", "listItem", "modal"]

  connect() {
    console.log("check_controller connected")
    // Set the initial icon state based on data-checked attribute
    this.iconTargets.forEach(icon => {
      const isChecked = icon.dataset.checked === "true"
      if (isChecked) {
        this.setCheckedIcon(icon)
      } else {
        this.setUncheckedIcon(icon)
      }
    })
    this.pendingCheck = null
  }

  toggle(event) {
    console.log("check_controller toggle fired")
    const icon = event.currentTarget
    const listItem = icon.closest("li")
    const listId = listItem.dataset.listId
    const dueDate = listItem.querySelector("[data-due-date]").dataset.dueDate
    const isChecked = icon.dataset.checked === "true"

    // Toggle check/uncheck
    if (isChecked) {
      this.setUncheckedIcon(icon)
      icon.dataset.checked = "false"
      this.persistCheck(listId, dueDate, false)
    } else {
      this.pendingCheck = { icon, listId, dueDate }
      this.openModal()
      return
    }

    // Reorder the list by checked/unchecked and due_date
    // this.sortByCheckedAndDueDate(parentUl)
  }

  choosePayment(event) {
    if (!this.pendingCheck) return
    const paymentMethod = event.currentTarget.dataset.paymentMethod
    const { icon, listId, dueDate } = this.pendingCheck
    this.setCheckedIcon(icon)
    icon.dataset.checked = "true"
    this.persistCheck(listId, dueDate, true, paymentMethod)
    this.pendingCheck = null
    this.closeModal()
  }

  cancelPayment() {
    this.pendingCheck = null
    this.closeModal()
  }

  openModal() {
    if (this.hasModalTarget) {
      this.modalTarget.classList.remove("hidden")
      this.modalTarget.classList.add("flex")
    }
  }

  closeModal() {
    if (this.hasModalTarget) {
      this.modalTarget.classList.add("hidden")
      this.modalTarget.classList.remove("flex")
    }
  }

  persistCheck(listId, dueDate, checked, paymentMethod = null) {
    fetch(`/lists/${listId}/check_list_histories`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({
        checked,
        due_date: dueDate,
        payment_method: paymentMethod
      })
    })
  }

  setCheckedIcon(icon) {
    icon.innerHTML = `
      <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-black" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
      </svg>
    `
  }

  setUncheckedIcon(icon) {
    icon.innerHTML = `
      <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12H9m12 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
      </svg>
    `
  }

  sortByCheckedAndDueDate(parentUl) {
    // Convert the list of <li> items into an array for sorting
    const items = Array.from(parentUl.children)

    // Sort items first by checked/unchecked, then by due_date
    items.sort((a, b) => {
      // Get the checked state
      const checkedA = a.querySelector("[data-checked]").dataset.checked === "true" ? 1 : 0
      const checkedB = b.querySelector("[data-checked]").dataset.checked === "true" ? 1 : 0

      // First, sort by checked state (unchecked first)
      if (checkedA !== checkedB) {
        return checkedA - checkedB
      }

      // If both are checked or both are unchecked, sort by due_date
      const dateA = new Date(a.querySelector("[data-due-date]").dataset.dueDate)
      const dateB = new Date(b.querySelector("[data-due-date]").dataset.dueDate)
      return dateA - dateB
    })

    // Append items back into the <ul> in the sorted order
    items.forEach(item => parentUl.appendChild(item))
  }
}
