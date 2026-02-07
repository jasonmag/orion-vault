import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["methodSelect", "cardField", "cardSelect"]

  connect() {
    this.update()
  }

  update() {
    const isCard = this.methodSelectTarget.value === "card"

    this.cardFieldTarget.hidden = !isCard
    this.cardSelectTarget.disabled = !isCard
    this.cardSelectTarget.required = isCard

    if (!isCard) {
      this.cardSelectTarget.value = ""
    }
  }
}
