const purgecss = require('@fullhuman/postcss-purgecss')({
  content: ['src/**/*.{html,js,elm}'],

  // change the default extractor to match classes such as sm:p-4
  defaultExtractor: content => content.match(/[A-Za-z0-9-_:/]+/g) || [],
})

module.exports = {
  plugins: [
    require('postcss-import'),
    require('tailwindcss')('./tailwind.config.js'),
    require('autoprefixer'),
    ...(process.env.NODE_ENV === 'production'
      ? [purgecss]
      : []
    ),
  ]
}
