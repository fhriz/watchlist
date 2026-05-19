import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {
  static targets = ["query", "status"]
  static values = { delay: { type: Number, default: 300 } }

  connect() {
    this.timeout = null
  }

  submit() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, this.delayValue)
  }

  submitNow() {
    clearTimeout(this.timeout)
    this.element.requestSubmit()
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
