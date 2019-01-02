# purs-cssom

### What is this?

An experiment in chucking a load of crap in a big stylesheet to see if that's performant or even sensible. I *believe* this is how many other CSS-in-JS libraries work but don't hold me to that.

This one keeps a Map full of them in a ref so we can update over time. I suppose the thing would be to have a library write all it's new calculated styles on render and then grab them all and fire them into this which would chuck them in the CSSOM all at once.

### Does it work?

Broadly, yes. Whether it's performant or not is yet to be seen.

### Can I try it?

Uhh. Sure.

`git clone https://github.com/danieljharvey/purs-cssom`

`psc-package install`

`yarn start` and then `open index.html`. Joy!
