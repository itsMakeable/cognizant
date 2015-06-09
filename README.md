## Structure
```
--
  |
  |- Build - Gulp tasks and other files not associated with the actual site
  |
  |- Src - Preprocessed files
     |
     |- coffee - proprocessed JS files
     |
     |- font - font files before being processed as Base64 CSS files
     |
     |- img - images prior to minification
     |
     |- jade - proprocessed HTML files
     |
     |- styl - proprocessed CSS files
     |
     |- svg - svg prior to minification and symbol creation https://css-tricks.com/svg-symbol-good-choice-icons/
  |
  |- Docs - Dynamically Generated Documentation
  |
  |- Tmp - Temporary files created as part of the build process
  |
  |- App - The Site
```

## Build
If not already installed, install Node, on a Mac:

`brew i node`

If not already installed globally, install gulp and bower:

`npm i gulp bower -g`

Install Bower Front-End Components:

`bower i`

Install Node Build Components:

`npm i`

$$$:

`gulp`


## Notes

### It is very importnat that each gradient SVG need to have a unique fill ID. The exception being icons that are repeated and are the same size. If the icon is on the page more than once at a different size, the two different sized icons need to have different fill IDs. Search icon_pdf-unique-ID-01 through icon_pdf-unique-ID-04 and examine how each is used to get the idea.


### JS Plugin Requirements
Head.js: loads in the head of the document to provide specific classes relevatant to the browser in order to profive fallback css for certain things like gradients. It also provides async js and css loading. headjs.com

Waypoints - Provides events for scrolling interactions. http://imakewebthings.com/waypoints/

Velocity - An animation engine http://julian.com/research/velocity/

Perfect-scrollbar - Used in scrolling elements where the native scrollbar is not ideal. http://noraesae.github.io/perfect-scrollbar/

Aload - Provides extremely simple async asset loading and is loaded directly in the head of the document. https://github.com/pazguille/aload


### General

If images or svg are not being processed as expected, run `gulp clear` to clear the cache.

Wireframes: http://wa7puw.axshare.com/#p=cover

