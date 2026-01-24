import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "image"]
  static values = {
    images: Array,
    currentIndex: Number
  }

  connect() {
    this.boundKeyHandler = this.handleKeydown.bind(this)
  }

  open(event) {
    event.preventDefault()
    const index = parseInt(event.currentTarget.dataset.index, 10)
    this.currentIndexValue = index
    this.showImage()
    this.overlayTarget.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")
    document.addEventListener("keydown", this.boundKeyHandler)
  }

  close() {
    this.overlayTarget.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")
    document.removeEventListener("keydown", this.boundKeyHandler)
  }

  previous(event) {
    event?.preventDefault()
    if (this.currentIndexValue > 0) {
      this.currentIndexValue--
      this.showImage()
    }
  }

  next(event) {
    event?.preventDefault()
    if (this.currentIndexValue < this.imagesValue.length - 1) {
      this.currentIndexValue++
      this.showImage()
    }
  }

  showImage() {
    const image = this.imagesValue[this.currentIndexValue]
    this.imageTarget.src = image.url
    this.imageTarget.alt = image.alt || ""
  }

  handleKeydown(event) {
    switch (event.key) {
      case "Escape":
        this.close()
        break
      case "ArrowLeft":
        this.previous()
        break
      case "ArrowRight":
        this.next()
        break
    }
  }

  // Close when clicking the backdrop (but not the image)
  backdropClick(event) {
    if (event.target === this.overlayTarget) {
      this.close()
    }
  }
}
