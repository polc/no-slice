const purgecss = require('@fullhuman/postcss-purgecss')({
  content: ['src/**/*.{html,js,elm}'],
})

module.exports = {
  plugins: [
    require('postcss-import'),
    require('tailwindcss'),
    require('autoprefixer'),
    ...(process.env.NODE_ENV === 'production'
      ? [purgecss]
      : []
    ),
  ]
}
