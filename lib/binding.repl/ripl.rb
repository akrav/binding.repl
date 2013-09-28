predicate = lambda do
  defined?(Ripl)
end
runner = lambda do |binding, options|
  Ripl.start options.merge(binding: binding)
end
Binding.repl.add :ripl, predicate, runner
