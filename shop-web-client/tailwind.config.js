module.exports = {
  theme: {
    extend: {
      spacing: {
        '72': '18rem',
        '84': '21rem',
        '96': '24rem',
      },
      borderRadius: {
        '4xl': '3rem',
      },
      fontFamily: {
        'display': ['"Harmonia Sans W01"', 'system-ui', '-apple-system', 'BlinkMacSystemFont', '"Segoe UI"', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', '"Droid Sans"', '"Helvetica Neue"', '"Fira Sans"', 'sans-serif'],
      },
      customForms: theme => ({
        default: {
          input: {
            backgroundColor: theme('colors.gray.200'),
            '&:focus': {
              outline: 'none',
              boxShadow: 'none',
              borderColor: theme('colors.green.700'),
              backgroundColor: theme('colors.white'),
            }
          },
          textarea: {
            backgroundColor: theme('colors.gray.200'),
            '&:focus': {
              outline: 'none',
              boxShadow: 'none',
              borderColor: theme('colors.green.700'),
              backgroundColor: theme('colors.white'),
            }
          },
          checkbox: {
            borderColor: theme('colors.green.700'),
            backgroundColor: theme('colors.gray.200'),
          },
        },
      })
    },
  },
  variants: {},
  plugins: [
    require('@tailwindcss/custom-forms'),
  ]
}
