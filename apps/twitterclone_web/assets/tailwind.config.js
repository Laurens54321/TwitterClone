// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

let plugin = require('tailwindcss/plugin')

module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex',
    '../lib/*_web/**/*.html.leex'
  ],
  darkMode: 'class',
  variants: {
    extend: {
        display: ["group-hover"],
    },
  },
  theme: {
    extend: {
      colors: {
        'dark': '#36393f',
        'lightdark': '#3c3f45',
        'deepdark': '#202225',
        'textclr': '#bdc1c6',
        'darktextclr': '#8c8f93',
        'fancyclr': 'from-pink-500'
      },
    },
    

  },
  plugins: [
    require('@tailwindcss/forms'),
    plugin(({addVariant}) => addVariant('phx-no-feedback', ['&.phx-no-feedback', '.phx-no-feedback &'])),
    plugin(({addVariant}) => addVariant('phx-click-loading', ['&.phx-click-loading', '.phx-click-loading &'])),
    plugin(({addVariant}) => addVariant('phx-submit-loading', ['&.phx-submit-loading', '.phx-submit-loading &'])),
    plugin(({addVariant}) => addVariant('phx-change-loading', ['&.phx-change-loading', '.phx-change-loading &'])),
  ]
}
