#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'optparse'
require 'yaml'

config = YAML.load(File.open("config.yml"))

puts <<EOS
<div class="colophon">
  <p class="title">#{config["booktitle"]}</p>
EOS

puts <<EOT
  <table>
EOT
puts %Q[<tr>\n <th>著　者</th><td>#{config["aut"]}</td>\n</tr>] if config["aut"]
puts %Q[<tr>\n <th>サークル</th><td>#{config["cir"]}</td>\n</tr>] if config["cir"]
puts %Q[<tr>\n <th>表紙デザイン</th><td>早水 桃子</td>\n</tr>]
puts %Q[<tr>\n <th>ウェブサイト</th><td><a href="http://hayamiz.com/~hotchpotch/">http://hayamiz.com/~hotchpotch/</a></td>\n</tr>]
puts <<EOS
  </table>
EOS
if config["pubhistory"]
  puts %Q[<div class="pubhistory">\n<p>#{config["pubhistory"].gsub(/\n/,"<br />")}</p>\n</div>]
end
puts <<EOS
</div>
EOS
