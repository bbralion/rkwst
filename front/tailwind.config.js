const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: ["./index.html", "./src/**/*.{js,res}"],
  theme: {
    extend: {
      fontFamily: {
        sans: ['"M PLUS Code Latin"', ...defaultTheme.fontFamily.sans],
        heading: ['"M PLUS 2"', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [],
};
