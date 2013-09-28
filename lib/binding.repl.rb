klass = Class.new do
  const_set :BindingMixin, Module.new {
    def repl
      Binding.repl.new(self)
    end

    def repl!
      Binding.repl.new(self).automatic!
    end
  }

  def self.version
    "0.1.1.1"
  end

  def self.automatic_load_order=(order)
    @automatic_load_order = order
  end

  def self.automatic_load_order
    @automatic_load_order
  end

  def initialize(binding)
    @binding = binding
  end

  def automatic!(options = {})
    Binding.repl.automatic_load_order.each do |repl|
      begin
        public_send(repl, options)
      rescue LoadError => e
        warn e.message
      else
        return true # we found a REPL, quit.
      end
    end
  end

  def pry(options = {})
    safe_require "pry", defined?(Pry)
    @binding.pry options
  end

  def ripl(options = {})
    safe_require "ripl", defined?(Ripl)
    Ripl.start options.merge(:binding => @binding)
  end

  def irb(options = nil)
    # Insane API, but here it is (IRB.start() doesn't take binding).
    safe_require "irb", defined?(IRB)
    IRB.setup(nil)
    irb = IRB::Irb.new IRB::WorkSpace.new(@binding)
    IRB.conf[:IRB_RC].call(irb.context) if IRB.conf[:IRB_RC]
    IRB.conf[:MAIN_CONTEXT] = irb.context
    trap("SIGINT") do
      irb.signal_handle
    end
    catch(:IRB_EXIT) do
      irb.eval_input
    end
  end

private
  def safe_require(lib, already_loaded)
    unless already_loaded
      require(lib)
    end
  rescue LoadError => e
    raise e, "the ruby console '#{lib}' could not be loaded. is '#{lib}' installed?"
  end
end

Binding.class_eval do
  define_singleton_method(:repl) { klass }
  include Binding.repl::BindingMixin
  repl.automatic_load_order = %w(ripl pry irb)
end
