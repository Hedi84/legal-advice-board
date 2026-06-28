import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["star", "input"]

  highlight(event) {
    this.updateStars(parseInt(event.currentTarget.dataset.value))
  }

  reset() {
    this.updateStars(parseInt(this.inputTarget.value) || 0)
  }

  select(event) {
    this.inputTarget.value = event.currentTarget.dataset.value
  }

  updateStars(value) {
    this.starTargets.forEach((star, i) => {
      star.textContent = i < value ? "★" : "☆"
      star.classList.toggle("star-picker__star--filled", i < value)
    })
  }
}
