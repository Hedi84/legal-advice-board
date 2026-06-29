import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]
  static values = { delay: { type: Number, default: 3000 } }

  pay(event) {
    if (this.submitting || this.delayValue === 0) return

    event.preventDefault()

    this.buttonTarget.textContent = "Processing..."
    this.buttonTarget.disabled = true

    setTimeout(() => {
      this.submitting = true
      this.element.requestSubmit()
    }, this.delayValue)
  }
}
