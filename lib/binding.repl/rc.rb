module Binding.repl::RC
  module_function
  def home_rc
    File.join ENV["HOME"], ".binding.repl.rc"
  end

  def safe_load
    if File.readable?(home_rc)
      blob = File.read(home_rc)
      rc = JSON.parse File.read(home_rc)
      Binding.repl.auto_load_order = rc["auto_load_order"]
    end
  rescue StandardError => e
    warn "binding.repl: '#{home_rc}' read failed (#{e.class}): #{e.message}"
  end
end

if ENV["BINDING_REPL_ORDER"].nil? && ENV["BINDING_REPL_RC"] != "0"
  require "json"
  Binding.repl::RC.safe_load
end
if ENV.has_key?("BINDING_REPL_ORDER")
  Binding.repl.auto_load_order = ENV["BINDING_REPL_ORDER"].split /[:,]/
end
