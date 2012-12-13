#!/usr/bin/env ruby

$id = 100
def proc_block(block)
  footnotes = []
  block = block.gsub(/\\footnote\{([^\}]*)\}/) do |m|
    $id += 1
    footnotes.push("//footnote[momoko-#{$id}][#{$1}]")
    "@<fn>{momoko-#{$id}}"
  end
  block + "\n" + footnotes.join("\n")
end

def main
  file = ARGV.first
  blocks = File.open(file).read.split("\n\n")
  blocks = blocks.map{|b| proc_block(b)}
  puts blocks.join("\n\n")
end

main
