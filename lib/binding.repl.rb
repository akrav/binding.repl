klass = Class.new do
  module Mixin
    def repl
      Binding.repl.new(self)
    end
  end

  def self.version
    "0.1.0"
  end

  def initialize(binding)
    @binding = binding
  end

  def pry(options = {})
    safe_require "pry", defined?(Pry)
    @binding.pry options
  end

  def ripl(options = {})
    safe_require "ripl", defined?(Ripl)
    Ripl.start options.merge(:binding => @binding)
  end

private
  def safe_require(file, already_loaded)
    unless already_loaded
      require file
    end
  rescue LoadError => e
    warn "the file '#{file}' could not be loaded."
  end
end

Binding.class_exec(klass) do |klass|
  define_singleton_method(:repl) do
    klass
  end
  include Binding.repl::Mixin
end

class Foo
  binding.repl.pry
end
