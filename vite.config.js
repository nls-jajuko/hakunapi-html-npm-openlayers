import { defineConfig } from "vite";

const path = require('path')

module.exports = defineConfig({
  build: {
    lib: {
      entry: path.resolve(__dirname, 'main.js'),
      name: 'M',
      fileName: (format) => `hakunapi-html-map.${format}.js`
    }
  }
});