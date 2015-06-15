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

## Build Cognizant
You will need to have Node, Git, Bower, and Gulp installed globally and available in your path. If you already have these dependencies installed, test to be sure, then skip to step 6. You can test any dependency by running the command followed by ' -v'. For instance, `node -v` will return the version of node installed.

###### Please follow carefully in order:

1. Install Node 
	* on a Mac: `brew i node`
	* on Windows: Follow the instructions here: http://blog.teamtreehouse.com/install-node-js-npm-windows
  
2. Test Node `node -v.` This will return the version installed.
  
3. If not already installed globally, install gulp and bower:
`npm i gulp -g`

4. Test to check it was installed properlly and in your path. `gulp -v`. This will return the version installed.

5. Make sure you inside the project folder. `cd cognizant`

6. Install Node Build Components: `npm install`

7. Run `gulp`. This will run all build tasks and start an auto-reloading server.

8. Open http://localhost:8088 and http://localhost:8088/styleguide in your browser.


## Notes

### JS Plugin Requirements
* Head.js: loads in the head of the document to provide specific classes relevatant to the browser in order to profive fallback css for certain things like gradients. It also provides async js and css loading. headjs.com

* Waypoints - Provides events for scrolling interactions. http://imakewebthings.com/waypoints/

* Velocity - An animation engine http://julian.com/research/velocity/

* Perfect-scrollbar - Used in scrolling elements where the native scrollbar is not ideal. http://noraesae.github.io/perfect-scrollbar/

* Aload - Provides extremely simple async asset loading and is loaded directly in the head of the document. https://github.com/pazguille/aload


### General

If images or svg are not being processed as expected, run `gulp clear` to clear the cache.

Wireframes: http://wa7puw.axshare.com/#p=cover

