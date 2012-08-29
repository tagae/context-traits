---
layout: page
---

Getting Started
---------------

### In the browser

Download the [production version] or [development version] of the library, and load it in your page as usual:

{% highlight html %}
<script src="context-traits.js"></script>
{% endhighlight %}

To load the library in an arbitrary namespace (for example `cop`) do:

{% highlight html %}
<script>this.exports = cop;</script>
<script src="context-traits.js"></script>
{% endhighlight %}

Don't forget to include the library dependencies, [Underscore] and
[Traits].

### On the server (coming soon)

Install the module with:

{% highlight sh %}
npm install context-traits
{% endhighlight %}

And load it as usual:

{% highlight javascript %}
var cop = require('context-traits');
{% endhighlight %}

Diving In
---------

- [Project repository](https://github.com/tagae/context-traits)
- [Annotated source code](docs/prologue.html)
- [Browser compatibility](test/)


[production version]: https://raw.github.com/tagae/context-traits/gh-pages/dist/context-traits.min.js
[development version]: https://raw.github.com/tagae/context-traits/gh-pages/dist/context-traits.js
[Underscore]: http://documentcloud.github.com/underscore/
[Traits]: http://traitsjs.org/
