| Project         | binding.repl
|:----------------|:--------------------------------------------------
| Homepage        | https://github.com/robgleeson/binding.repl
| Documentation   | http://rubydoc.info/github/robgleeson/binding.repl
| CI              | [![Build Status](https://travis-ci.org/robgleeson/ichannel.binding.repl.png)](https://travis-ci.org/robgleeson/binding.repl)
| Author          | Robert Gleeson

__DESCRIPTION__

__binding.repl__ can start a number of different ruby consoles at runtime.
IRB, ripl, and pry(of course!) can be invoked at runtime in any context
that an instance of `Binding` closes over.

I owe all credit to John Mair([banisterfiend](https://github.com/banister)),
the creator of Pry, for seeing the potential in a console that can be
started at runtime and bound to the context of a `Binding`. I don't
think a single ruby console has put as much emphasize on a console
that be invoked at runtime as Pry has.

the interface to invoke Pry at runtime is very accessible and easy to
use but if you look at other ruby console implementations you might find
the eval() of code is the same. It happens through `Binding#eval` which
closes over a context(maybe the context is "Foo", a class, or an
instance of "Foo").

__binding.repl__ provides the same `binding.pry` interface to all ruby
consoles (if I missed one, open an issue or send an e-note :)).

__EXAMPLES__

```ruby
class BlogsController < ApplicationController
  def show
    @blog = Blog.find(params[:id])
    # invoke pry,irb, or ripl in the context of the 'show' method.
    binding.repl.{pry,irb,ripl}
  end
end

class Bar
  # auto discover the first available console.
  # default order is: ripl, pry, or irb.
  binding.repl.auto

  # change default load order
  Binding.repl.auto_load_order = %w(pry ripl irb)

  # remove "irb" from auto discovery
  Binding.repl.auto_load_order -= ["irb"]
end
```

__NOTES__

_CONFIGURATION_

ripl and pry can be customized by passing a set of key-value pairs but
IRB isn't as straight forward to configure and I haven't implemented
any customization options for it yet.

ripl can be invoked with options that are forwarded to `Ripl.start(…)`:

```ruby
class Foo
  binding.repl.ripl riplrc: false
end
```

pry can be configured in the same way. options are forwarded to `Pry.start(…)`:

```ruby
class Foo
  binding.repl.pry quiet: true
end
```

_RIPL & IRB_

I have only used Ripl once(to write this library) and I don't use IRB
much anymore. If I can improve support for either please let me know
via an issue or pull request/e-note.


_DEPENDENCIES_

binding.repl doesn't depend on anything. it's up to you to meet the
dependencies(pry, irb, and/or ripl). `binding.repl.{ripl,pry,irb}`
will try to load the appropiate console for you if it looks like it
hasn't been loaded yet.

__INSTALL__

ruby 1.9+ only.

```
gem install binding.repl
```

__CREDIT__

- [banisterfiend](https://github.com/banister) (John Mair)
  for pry

- [Kyrylo](https://github.com/kyrylo) (Kyrylo Silin)
  for his hard work on pry.

Rest of the Pry team(!!):

- [cirwin](https://github.com/conradirwin), Conrad Irwin.
- [ryanf](https://github.com/rf-), Ryan Fitzgerald.
- [rking](https://github.com/rking), "rking", on adventures outside programming now.

__LICENSE__

MIT.

__CONTRIBUTING__

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new E-Note
