predicate = lambda do
  defined?(Pry)
end
runner = lambda do |binding, options|
  binding.public_send :pry, options
end
Binding.repl.add :pry, predicate, runner
