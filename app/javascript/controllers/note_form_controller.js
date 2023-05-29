import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['form']

    submit(event) {
        event.preventDefault()
        this.formTarget.requestSubmit()
    }

    preventEnterSubmit(event) {
        if (event.key === 'Enter') {
            event.preventDefault()
        }
    }
}
