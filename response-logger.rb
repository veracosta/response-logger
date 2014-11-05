#!/usr/bin/ruby
sleep 1
puts "Select the protocol with number that you want to check."
print "\n 1) http\n 2) dns\n"
typenumber = $stdin.gets.to_i
case typenumber
when 1
  plugintype = "http" 
when 2
  plugintype = "dns"
end
plugin_path = "/usr/lib64/nagios/plugins/check_#{plugintype}"

# プラグインのパスをチェック
while !File.exist?(plugin_path)
  puts "Error: Could not find Nagios Plugin(check_#{plugintype})."
  print "Enter the plugin path:"
  input = $stdin.gets
  plugin_path = input.chomp
end

## 共通パラメータ
target_host = ARGV[0]
if target_host.nil?
  puts "Error: target hostname must be specified as a parameter."
  puts "For example, \"ruby nagios-plugin-logger(v0.2).rb example.com\""
  exit(status = false)
end

interval = ARGV[1]
if interval.nil?
  interval = 10
end

optional_parameter = ARGV[2]
if optional_parameter.nil?
  optional_parameter = ""
end


puts "Specify the destination of the output log file with full path.\n Default(leave here blank): /var/log/check_#{plugintype}/"
input = $stdin.gets
output_path = input.chomp
if output_path.empty?
  output_path = "/var/log/check_#{plugintype}/"
  puts "Output path will be #{output_path}"
end
if !File.exist?(output_path)
  `mkdir -p #{output_path}`
end

puts "Executing..."
loop{
  print "\\(^o^)/"
  day = Time.now
  File.open("#{output_path}check_#{plugintype}_#{target_host}-#{day.year}-#{day.month}-#{day.day}.log", "a") do |io|
    cmd = `#{plugin_path} #{target_host} #{optional_parameter}`
    result = $?.exitstatus
    if result == 2 then
      io.puts "#{day}\t0"
    else
      response_time = cmd.match(/(\d?\.\d\d\d?)/)
      io.puts "#{day}\t#{target_host}\t#{response_time}"
    end
  end
  sleep(interval.to_i)
}