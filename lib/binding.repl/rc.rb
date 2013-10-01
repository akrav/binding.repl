require "json"
module Binding.repl::Tryable
  def try
    rc = yield
  rescue StandardError => e
    warn "error reading JSON file $HOME/.binding.repl.rc (#{e.class}: #{e.message})"
  else
    Binding.repl.auto_load_order = rc["auto_load_order"]
  end
  module_function :try
end

home_rc = File.join ENV["HOME"], ".binding.repl.rc"
if File.exists?(home_rc)
  Binding.repl::Tryable.try do
    blob = File.read home_rc
    options = JSON.parse(blob)
  end
end
