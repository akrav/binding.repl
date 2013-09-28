class BindingRepl
  module BindingMixin
    def repl
      Binding.repl.new(self)
    end
  end

  LOOKUP = {}
  LOOKUP.default = [proc { true }, proc { :'binding.repl.unknown_console' }]
  private_constant :LOOKUP

  def self.name
    "binding.repl"
  end

  def self.inspect
    name
  end

  def self.version
    "0.2.0"
  end

  def self.add(console, predicate, runner)
    LOOKUP[console] = [predicate, runner]
    define_method(console) do |options = {}|
      exit_value = invoke_console(console, options)
      error?(exit_value) ? fail!(console) : exit_value
    end
  end

  def self.auto_load_order=(order)
    @auto_load_order = order
  end

  def self.auto_load_order
    @auto_load_order
  end

  def initialize(binding)
    @binding = binding
    @lookup = LOOKUP
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
end

klass = BindingRepl
Object.send :remove_const, :BindingRepl
Binding.class_eval do
  define_singleton_method(:repl) { klass }
  include klass::BindingMixin
  repl.auto_load_order = %w(ripl pry irb)
end
require_relative "binding.repl/pry"
require_relative "binding.repl/irb"
require_relative "binding.repl/ripl"
