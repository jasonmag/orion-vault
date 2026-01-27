import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["startInput", "endInput", "grid", "monthLabel", "rangeLabel"]

  connect() {
    const today = new Date()
    this.currentMonth = new Date(today.getFullYear(), today.getMonth(), 1)
    this.startDate = this.parseInputDate(this.startInputTarget.value)
    this.endDate = this.parseInputDate(this.endInputTarget.value)

    if (this.startDate) {
      this.currentMonth = new Date(this.startDate.getFullYear(), this.startDate.getMonth(), 1)
    }

    this.render()
  }

  prevMonth() {
    this.currentMonth = new Date(this.currentMonth.getFullYear(), this.currentMonth.getMonth() - 1, 1)
    this.render()
  }

  nextMonth() {
    this.currentMonth = new Date(this.currentMonth.getFullYear(), this.currentMonth.getMonth() + 1, 1)
    this.render()
  }

  clear() {
    this.startDate = null
    this.endDate = null
    this.startInputTarget.value = ""
    this.endInputTarget.value = ""
    this.render()
  }

  selectDate(event) {
    const iso = event.currentTarget.dataset.date
    if (!iso) {
      return
    }

    const clicked = this.parseInputDate(iso)
    if (!clicked) {
      return
    }

    if (!this.startDate || this.endDate) {
      this.startDate = clicked
      this.endDate = null
    } else if (clicked.getTime() >= this.startDate.getTime()) {
      this.endDate = clicked
    } else {
      this.endDate = this.startDate
      this.startDate = clicked
    }

    this.startInputTarget.value = this.formatDate(this.startDate)
    this.endInputTarget.value = this.endDate ? this.formatDate(this.endDate) : ""
    this.render()
  }

  render() {
    this.renderMonthLabel()
    this.renderGrid()
    this.renderRangeLabel()
  }

  renderMonthLabel() {
    const formatter = new Intl.DateTimeFormat("en-US", { month: "long", year: "numeric" })
    this.monthLabelTarget.textContent = formatter.format(this.currentMonth)
  }

  renderGrid() {
    const start = this.firstCalendarDate(this.currentMonth)
    const days = []
    for (let i = 0; i < 42; i += 1) {
      const date = new Date(start.getFullYear(), start.getMonth(), start.getDate() + i)
      days.push(date)
    }

    this.gridTarget.innerHTML = ""
    days.forEach((date) => {
      const button = document.createElement("button")
      button.type = "button"
      button.textContent = String(date.getDate())
      button.dataset.date = this.formatDate(date)
      button.className = this.dayClass(date)
      button.setAttribute("data-action", "date-range#selectDate")
      this.gridTarget.appendChild(button)
    })
  }

  renderRangeLabel() {
    if (!this.startDate) {
      this.rangeLabelTarget.textContent = "Select a start date"
      return
    }

    if (!this.endDate) {
      this.rangeLabelTarget.textContent = `Start: ${this.formatLabel(this.startDate)}`
      return
    }

    this.rangeLabelTarget.textContent = `${this.formatLabel(this.startDate)} – ${this.formatLabel(this.endDate)}`
  }

  dayClass(date) {
    const inCurrentMonth = date.getMonth() === this.currentMonth.getMonth()
    const isStart = this.isSameDay(date, this.startDate)
    const isEnd = this.isSameDay(date, this.endDate)
    const inRange = this.isInRange(date)

    const base = "h-9 w-9 rounded-full text-sm font-medium transition"
    const muted = inCurrentMonth ? "text-white" : "text-slate-500"
    const hover = "hover:bg-slate-800"

    if (isStart || isEnd) {
      return `${base} bg-white text-slate-900`
    }

    if (inRange) {
      return `${base} bg-slate-700 text-white`
    }

    return `${base} ${muted} ${hover}`
  }

  isInRange(date) {
    if (!this.startDate || !this.endDate) {
      return false
    }

    const time = this.stripTime(date).getTime()
    const start = this.stripTime(this.startDate).getTime()
    const end = this.stripTime(this.endDate).getTime()

    return time >= start && time <= end
  }

  isSameDay(a, b) {
    if (!a || !b) {
      return false
    }

    return (
      a.getFullYear() === b.getFullYear() &&
      a.getMonth() === b.getMonth() &&
      a.getDate() === b.getDate()
    )
  }

  firstCalendarDate(monthDate) {
    const firstOfMonth = new Date(monthDate.getFullYear(), monthDate.getMonth(), 1)
    const day = firstOfMonth.getDay()
    const mondayIndex = day === 0 ? 6 : day - 1
    return new Date(firstOfMonth.getFullYear(), firstOfMonth.getMonth(), 1 - mondayIndex)
  }

  parseInputDate(value) {
    if (!value) {
      return null
    }

    const parts = value.split("-").map((part) => Number(part))
    if (parts.length !== 3 || parts.some((part) => Number.isNaN(part))) {
      return null
    }

    const [year, month, day] = parts
    return new Date(year, month - 1, day)
  }

  formatDate(date) {
    if (!date) {
      return ""
    }

    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, "0")
    const day = String(date.getDate()).padStart(2, "0")
    return `${year}-${month}-${day}`
  }

  formatLabel(date) {
    const formatter = new Intl.DateTimeFormat("en-US", { month: "short", day: "numeric" })
    return formatter.format(date)
  }

  stripTime(date) {
    return new Date(date.getFullYear(), date.getMonth(), date.getDate())
  }
}
