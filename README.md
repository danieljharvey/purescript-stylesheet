# purescript-stylesheet

### What is this?

A work in progress CSS-In-Purs that stores all the styles we want in a big hashmap and then updates the actual CSSOM whenever needed. 

### Does it work?

Broadly, yes. Whether it's performant or not is yet to be seen.

### Can I try it?

Uhh. Sure. To see a somewhat terrible looking proof of concept, crack open the
following incantations:

`git clone https://github.com/danieljharvey/purescript-stylesheet`

`spago install`

`yarn build` and then `open index.html`. Joy!
