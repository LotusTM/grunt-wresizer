# grunt-wresizer

Resize, watermark and optimize images like a pro

## Installation

1. Clone or download and unpack to desired location
2. Download and install latest version of [node.js](http://nodejs.org/)
3. Install grunt-cli globally: `npm install -g grunt-cli`
4. Install [GraphicsMagick](http://www.graphicsmagick.org/download.html) (recommended) or [ImageMagick](http://www.imagemagick.org/script/binary-releases.php) for your OS.
5. Get your TinyPNG [API key](https://tinypng.com/developers) and set it as your environment variable:
  * `set TINYPNG_API_KEY=YOUR_API_KEY_HERE` for Windows
  * `export TINYPNG_API_KEY=YOUR_API_KEY_HERE` for Linux
6. Install project dependencies: `npm install`
7. Put your watermark image in `source/watermark/` as `logo.png`
8. Configurate `grunt-gm` task

## How to use

  * `grunt` — clean, resize and watermark images
  * `grunt tinypng` — compress images with tynypng
  * `grunt build` — all operations
  * `grunt serve` — watch