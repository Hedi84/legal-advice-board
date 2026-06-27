import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  pay(event) {
    event.preventDefault()
    this.buttonTarget.textContent = "Processing..."
    this.buttonTarget.disabled = true

    setTimeout(() => {
      this.element.requestSubmit()
    }, 3000)
  }
}
