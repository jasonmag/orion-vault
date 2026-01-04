import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="frequency-tabs"
export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    const activeTab = this.tabTargets.find((tab) => tab.dataset.active === "true") || this.tabTargets[0]
    this.activate(activeTab)
  }

  show(event) {
    event.preventDefault()
    this.activate(event.currentTarget)
  }

  activate(tab) {
    if (!tab) return
    const value = tab.dataset.frequencyValue

    this.tabTargets.forEach((item) => {
      item.classList.remove(...this.classesFor(item.dataset.activeClass))
      item.classList.add(...this.classesFor(item.dataset.inactiveClass))
      item.setAttribute("aria-selected", "false")
    })

    tab.classList.remove(...this.classesFor(tab.dataset.inactiveClass))
    tab.classList.add(...this.classesFor(tab.dataset.activeClass))
    tab.setAttribute("aria-selected", "true")

    this.panelTargets.forEach((panel) => {
      panel.classList.toggle("hidden", panel.dataset.frequency !== value)
    })
  }

  classesFor(value) {
    return value ? value.split(" ") : []
  }
}
