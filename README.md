# grunt-wresizer

Resize, watermark and optimize images like a pro

## Installation

`npm install`

## Instructions

1. Get your TinyPNG [API key](https://tinypng.com/developers) and set it as your environment variable:
  * `set TINYPNG_API_KEY=YOUR_API_KEY_HERE` for Windows
  * `export TINYPNG_API_KEY=YOUR_API_KEY_HERE` for Linux
2. Run task:
  * Clean, resize and watermark: `grunt`
  * Compress with tynypng: `grunt tinypng`
  * All operations: `grunt build`
  * Watch: `grunt serve`