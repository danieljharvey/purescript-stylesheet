# purs-cssom

### What is this?

An experiment in chucking a load of crap in a big stylesheet to see if that's performant or even sensible. I *believe* this is how many other CSS-in-JS libraries work but don't hold me to that.

This one keeps a Map full of them in a ref so we can update over time. I suppose the thing would be to have a library collect a list of all it's new calculated styles whilst rendering and then this library puts them into the map, does a quick diff, and then updates the CSSOM with any changes.

### Does it work?

Broadly, yes. Whether it's performant or not is yet to be seen.

### Can I try it?

Uhh. Sure.

`git clone https://github.com/danieljharvey/purs-cssom`

`psc-package install`

`yarn start` and then `open index.html`. Joy!
