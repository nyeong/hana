# frozen_string_literal: true

module Hana
  # Lint an asciidoc files and update.
  module Lint
    # Public: Finds interdoc xrefs and updates titles
    #
    # Examples:
    #
    #   source = "- <<doc1#>>"
    #   titles = { 'doc1' => 'Index' }
    #   replace_interdoc_xrefs(source, titles)
    #   # => "- <<doc1#,Index>>"
    def self.replace_interdoc_xrefs(source, titles)
      is_block_opened = false
      source.lines.map do |line|
        case [line.match?(/^----$/), is_block_opened]
        in true, true
          is_block_opened = false
          line
        in true, false
          is_block_opened = true
          line
        in false, true
          line
        in false, false
          replace_interdoc_xrefs_line(line, titles)
        end
      end.join
    end

    def self.replace_interdoc_xrefs_line(line, titles)
      line.gsub(/(?<!`|\+)<<(.+?)#(.*?)>>/) do |xref|
        link = xref.match(/<<(.+?)#/)[1]
        title = titles[link]
        return xref unless title

        "<<#{link}#,#{title}>>"
      end
    end
  end
end
