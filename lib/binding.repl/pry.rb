predicate = lambda do
  defined?(Pry)
end
runner = lambda do |binding, options|
  binding.pry(options)
end
Binding.repl.add :pry, predicate, runner
