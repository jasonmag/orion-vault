const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        'greenleaf': '#bfcec6',
        'text-primary': '#4a4a4a',
        'accent-light': '#8a8d8f',
        'accent-dark': '#d6bfae',
        'cta-button': '#6a9c6e',
        'link': '#4a90e2',
        'highlight': '#e1b4a8',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
