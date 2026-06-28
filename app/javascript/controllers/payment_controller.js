import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]
  static values = { delay: { type: Number, default: 3000 } }

  pay(event) {
    event.preventDefault()
    this.buttonTarget.textContent = "Processing..."
    this.buttonTarget.disabled = true

    setTimeout(() => {
      this.element.requestSubmit()
    }, this.delayValue)
  }
}
