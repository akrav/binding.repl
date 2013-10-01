require "json"
module Binding.repl::RC
  def safe_load
    rc = yield
  rescue StandardError => e
    warn "error reading JSON file $HOME/.binding.repl.rc (#{e.class}: #{e.message})"
  else
    Binding.repl.auto_load_order = rc["auto_load_order"]
  end
  module_function :safe_load
end

home_rc = File.join ENV["HOME"], ".binding.repl.rc"
if File.exists?(home_rc)
  Binding.repl::RC.safe_load do
    JSON.parse File.read(home_rc)
  end
end
