require "json"
module Binding.repl::RC
  module_function
  def safe_load
    rc = JSON.parse File.read(home_rc)
  rescue StandardError => e
    warn "error reading JSON file '#{home_rc}' (#{e.class}: #{e.message})"
  else
    load_order = rc["auto_load_order"]
    Binding.repl.auto_load_order = load_order
  end

  def home_rc
    File.join ENV["HOME"], ".binding.repl.rc"
  end
end
if File.exists?(home_rc)
  Binding.repl::RC.safe_load
end
