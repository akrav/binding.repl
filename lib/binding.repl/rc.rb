require "json"
home_rc = File.join ENV["HOME"], ".binding.repl.rc"
local_rc = File.join Dir.getwd, ".binding.repl.rc"

if File.exists?(local_rc)
  json = File.read(local_rc)
else
  if File.exists?(home_rc)
    json = File.read(home_rc)
  end
end

if local_rc || home_rc
  options = JSON.parse(json) rescue nil
end
if options
  Binding.repl.auto_load_order = options["auto_load_order"]
end
