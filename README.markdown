Acts as Importable
==================

Originally written for Rails 2 / Ruby 1.8 by [Tim Riley](https://github.com/timriley).
Updated to Rails 3 by [Joe Martinez](https://github.com/capitalist).
Updated to Ruby 1.9.2 by [Pranas Kiziela](https://github.com/Pranas).
Coverage improved and additional hooks added by [Brandon Valentine](https://github.com/brandonvalentine).

Taste's good with Joe Martinez' [model_mill](https://rubygems.org/gems/model_mill/) gem.

[Importing Legacy Data in Rails](http://openmonkey.com/articles/2009/05/importing-legacy-data-in-rails) is currently the best source of documentation.

I (Brandon) have added a before_import hook, as well as before_import and after_import methods that can be defined on the legacy class.  If defined, the class methods are called before and after import_all and import_all_in_batches.  The instance method after_import is passed the new model object, and the class method after_import is passed an array of new model objects if and only if it's called from import_all.  import_all_in_batches is designed to save memory with large data sets, and thus passing the entire set of new model objects would defeat this goal.

This stuff is still a bit rough, but the specs pass, the coverage is much improved, and I can move on and use this in production.

TODO:

Refactor to use AR-style hooks, rather than relying on specially named methods.  That's a lame-o approach.

Copyright (c) 2009 Tim Riley, released under the MIT license
Some bits Copyright (c) 2011 Joe Martinez, released under the same
Some other bits Copyright (c) 2011 Pranas Kiziela, released under the same
Yet more bits Copyright (c) 2011 Brandon Valentine, released under the same
