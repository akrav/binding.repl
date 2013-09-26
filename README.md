| Project         | binding.repl
|:----------------|:--------------------------------------------------
| Homepage        | https://github.com/robgleeson/binding.repl
| Documentation   | http://rubydoc.info/github/robgleeson/binding.repl
| Metrics         | [![Code Climate](https://codeclimate.com/github/robgleeson/binding.repl.png)](https://codeclimate.com/github/robgleeson/binding.repl)
| CI              | [![Build Status](https://travis-ci.org/robgleeson/ichannel.binding.repl.png)](https://travis-ci.org/robgleeson/binding.repl)
| Author          | Robert Gleeson

__DESCRIPTION__

__binding.repl__ can start a number of different ruby consoles at runtime.
IRB, ripl, and Pry(of course!) can be invoked at runtime in any context
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
class Foo
  binding.repl.pry   # invoke pry in context of "Foo"
  binding.repl.ripl  # invoke ripl in context of "Foo"
  binding.repl.irb   # invoke irb in context of "Foo"
end
```

__CREDIT__

- [banisterfiend](https://github.com/banister) (John Mair)  
  for pry

- [Kyrylo](https://github.com/kyrylo) (Kyrylo Silin)  
  for his hard work on pry.

Rest of the Pry team(!!):

- [cirwin](https://github.com/conradirwin), Conrad Irwin.
- [ryanf](https://github.com/ryanf), Ryan Fitzgerald.

__LICENSE__

MIT.

__CONTRIBUTING__

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new E-Note
