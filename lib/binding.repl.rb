klass = Class.new do
  const_set :BindingMixin, Module.new {
    def repl
      Binding.repl.new(self)
    end
  }

  def self.version
    "0.2.0"
  end

  def self.auto_load_order=(order)
    @auto_load_order = order
  end

  def self.auto_load_order
    @auto_load_order
  end

  def initialize(binding)
    @binding = binding
    @lookup = {
      ripl: [-> { defined?(Ripl) } , method(:invoke_ripl).to_proc ],
      irb:  [-> { defined?(IRB) }  , method(:invoke_irb).to_proc  ],
      pry:  [-> { defined?(Pry) }  , method(:invoke_pry).to_proc  ]
    }
    @lookup.default = [proc { true }, proc {:'binding.repl.unknown_console'}]
  end

  def pry(options = {})
    exit_value = invoke_console :pry, options
    error?(exit_value) ? fail!(:pry) : exit_value
  end

  def ripl(options = {})
    exit_value = invoke_console :ripl, options
    error?(exit_value) ? fail!(:ripl) : exit_value
  end

  def irb(options = {})
    exit_value = invoke_console :irb, options
    error?(exit_value) ? fail!(:irb) : exit_value
  end

  def auto
    load_order = Binding.repl.auto_load_order
    load_order.each do |console|
      exit_value = invoke_console(console.to_sym, {})
      return exit_value unless error?(exit_value)
    end
    raise LoadError, "failed to load consoles: #{load_order.join(", ")}", []
  end

private
  def fail!(console)
    raise LoadError, "the console '#{console}' could not be loaded. is #{console} installed?", []
  end

  def error?(exit_value)
    exit_value.to_s.start_with? "binding.repl"
  end

  def invoke_console(console, options)
    require_predicate, runner = @lookup[console]
    require_console(console, require_predicate)
    runner.call(@binding, options)
  rescue LoadError
    :'binding.repl.load_error'
  end

  def require_console(console, predicate)
    already_required = predicate.call
    if !already_required
      require(console.to_s)
      # IRB hack.
      IRB.setup(nil) if console == :irb
    end
  end

  def invoke_pry(binding, options)
    binding.public_send :pry, options
  end

  def invoke_ripl(binding, options)
    Ripl.start options.merge(binding: binding)
  end

  def invoke_irb(binding, options)
    irb = IRB::Irb.new IRB::WorkSpace.new(binding)
    IRB.conf[:MAIN_CONTEXT] = irb.context
    trap("SIGINT") do
      irb.signal_handle
    end
    catch(:IRB_EXIT) do
      irb.eval_input
    end
  end
end

Binding.class_eval do
  define_singleton_method(:repl) { klass }
  include Binding.repl::BindingMixin
  repl.auto_load_order = %w(ripl pry irb)
end
