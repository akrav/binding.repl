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
    "0.7.0"
  end

  def self.disabled?
    @disabled
  end

  def self.enable!
    @disabled = false
    !@disabled
  end

  def self.disable!
    @disabled = true
  end

  def self.add(console, predicate, runner)
    LOOKUP[console] = [predicate, runner]
    define_method(console) do |options = {}|
      exit_value = invoke_console(console, options)
      invoke_failed?(exit_value) ? fail!(console) : exit_value
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
    load_order, exit_value = Binding.repl.auto_load_order, nil
    load_order.each do |console|
      exit_value = invoke_console(console.to_sym, {})
      return exit_value unless invoke_failed?(exit_value)
    end
    if invoke_failed?(exit_value)
      raise LoadError, "failed to load consoles: #{load_order.join(", ")}", []
    end
  end

private
  def fail!(console)
    raise LoadError, "the console '#{console}' could not be loaded. is #{console} installed?", []
  end

  def invoke_failed?(exit_value)
    exit_value = exit_value.to_s
    exit_value.start_with?("binding.repl") && exit_value != 'binding.repl.disabled'
  end

  def invoke_console(console, options)
    if Binding.repl.disabled?
      return :'binding.repl.disabled'
    end
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
require_relative "binding.repl/console/pry"
require_relative "binding.repl/console/irb"
require_relative "binding.repl/console/ripl"
require_relative "binding.repl/rc"
