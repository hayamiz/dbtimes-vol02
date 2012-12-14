#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# TeX article file convertor

require 'optparse'

def parse_args(argv)
  opt = Hash.new
  parser = OptionParser.new

  parser.banner = "#{$0} [options] TEX_FILE"

  opt[:some_option] = 'default value'
  parser.on('-o', '--option VALUE') do |value|
    opt[:some_option] = value
  end

  parser.parse!(argv)

  if argv.size != 1
    puts parser.help
    exit 1
  end
  opt[:file] = argv.shift

  unless opt[:file] =~ /\.tex\Z/
    $stderr.puts "TeX file required: #{opt[:file]}"
    puts parser.help
    exit 1
  end

  opt
end

LBRACE = "!!!LBRACE!!!"
RBRACE = "!!!RBRACE!!!"

def main(argv)
  opt = parse_args(argv)

  tex_file = opt[:file]
  basename = File.basename(tex_file, ".tex")

  str = File.read(tex_file)

  # strip comment
  str.gsub!(/^%.*\n?/, "")
  str.gsub!(/((?!\\).)%.*\n?/, "\\1")

  # make chapter/section/subsection an independent block
  str.gsub!(/(\\(?:chapter|(?:sub)*section))\{(.*)\}/) do |m|
    case $1
    when "\\chapter"
      prefix = "= "
    when "\\section"
      prefix = "== "
    when "\\subsection"
      prefix = "=== "
    when "\\subsubsection"
      prefix = "==== "
    else
      raise RuntimeError.new
    end

    "\n" + prefix + $2 + "\n"
  end

  # remove umlaut
  str.gsub!(/\\"{(.)}/) do |m|
    case $1
    when "o"
      "@<raw>#{LBRACE}|html|&ouml;#{RBRACE}"
    else
      raise RuntimeError.new
    end
  end

  # convert dash
  str.gsub!(/---/, "@<raw>#{LBRACE}|html|&mdash;#{RBRACE}")
  str.gsub!(/--/, "@<raw>#{LBRACE}|html|&ndash;#{RBRACE}")

  # ruby
  str.gsub!(/\\ruby\{([^\}]+)\}\{([^\}]+)\}/) do |m|
    "@<ruby>{#{$1},#{$2}}"
  end

  # double quote
  str.gsub!(/``([^']*)''/) do |m|
    "@<raw>#{LBRACE}|html|&ldquo;#{RBRACE}" + $1 + "@<raw>#{LBRACE}|html|&rdquo;#{RBRACE}"
  end

  str.gsub!(/"([^"]*)"/) do |m|
    "@<raw>#{LBRACE}|html|&ldquo;#{RBRACE}" + $1 + "@<raw>#{LBRACE}|html|&rdquo;#{RBRACE}"
  end

  # remove escape of %/_
  str.gsub!(/\\(%|_)/, "\\1")

  # footnote
  blocks = str.split(/\n\n+/)

  fnidx = 0
  next_fnid = lambda { fnidx += 1; basename + "-fn-" + fnidx.to_s}

  blocks = blocks.map do |block|
    footnotes = []
    block = block.gsub(/\\footnote\{([^\}]*)\}/) do |m|
      fnid = next_fnid.call()
      fntxt = $1.gsub(/\n/, "")
      footnotes.push("//footnote[#{fnid}][#{fntxt}]")
      "@<fn>{#{fnid}}"
    end
    if footnotes.size > 0
      block + "\n" + footnotes.join("\n")
    else
      block
    end
  end

  # Ad-hoc conversion of author name
  (0..3).each do |idx|
    block = blocks[idx]
    if block =~ /\\begin\{flushright\}(?:\s|\n)*(?:\{\\headfont)?\s*([^\}\\]+)\}?(?:\s|\n)*\\end\{flushright\}/
      blocks[idx] = "//raw[|html|<div style=\"text-align: right\">#{$~[1]}</div>]"
    end
  end

  str = blocks.join("\n\n")

  # recover braces
  str.gsub!(LBRACE, "{")
  str.gsub!(RBRACE, "}")

  puts str
end

if __FILE__ == $0
  main(ARGV.dup)
end
