predicate = lambda do
  defined?(IRB)
end

irb_setup = false
runner = lambda do |binding, options|
  unless irb_setup
    IRB.setup(nil)
    irb_setup = true
  end
  irb = IRB::Irb.new IRB::WorkSpace.new(binding)
  IRB.conf[:MAIN_CONTEXT] = irb.context
  trap("SIGINT") { irb.signal_handle }
  catch(:IRB_EXIT) { irb.eval_input }
end
Binding.repl.add :irb, predicate, runner
