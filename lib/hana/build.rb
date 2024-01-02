# frozen_string_literal: true

require 'asciidoctor'
require 'erb'
require 'fileutils'
require_relative './converter'

TEMPLATE_DIR = File.join(File.dirname(__FILE__), '../../templates')

module Hana
  # Build an adoc file into an html
  module Build
    TEMPLATE = ERB.new(File.read(File.join(TEMPLATE_DIR, 'adoc.html.erb')))
    # Represent adoc file fully compiled
    class Adoc
      attr_accessor :metadata, :content

      @@site = {
        baseurl: '/'
      }

      def initialize(metadata, template)
        @template = template
        @metadata = metadata
        @title = metadata.title
        attributes = {
          'source-highlighter' => 'rouge',
          'experimental' => 'true',
          'rouge-style' => 'github',
          'stem' => 'latexmath'
        }
        @content = Asciidoctor.convert metadata.content, converter: Converter, attributes:
      end

      # Render full HTML
      def to_html
        @template.result(binding)
      end

      # Write HTML file into dest directory
      def write!(dest_directory)
        Dir.mkdir(dest_directory) unless Dir.exist?(dest_directory)
        if @metadata.slug == 'index'
          index_path = File.join(dest_directory, 'index.html')
        else
          dest_directory = File.join(dest_directory, @metadata.slug)
          index_path = File.join(dest_directory, 'index.html')
          FileUtils.mkdir_p(dest_directory) unless Dir.exist?(dest_directory)
        end
        File.write(index_path, to_html)
      end
    end

    # Represent metadata for adoc file
    class Metadata
      attr_accessor :content
      attr_reader :absolute_path, :title, :slug

      def initialize(filename, source)
        @title = extract_title(source)
        @content = source
        @slug = filename.match(%r{.*/(.+?)\.adoc$})[1]
        @absolute_path = filename
      end

      def inspect
        "#<#{self.class} title=\"#{@title}\" slug=\"#{@slug}\" absolute_path=\"#{@absolute_path}\">"
      end

      def to_s
        inspect
      end

      def lint(slug_title_map)
        new = clone
        new.content = Lint.replace_interdoc_xrefs(@content, slug_title_map)
        new
      end

      private

      def extract_title(source)
        source.lines.first.match(/=\s*(.*)/)[1]
      end
    end

    # Public: Read an adoc file
    def self.read(source_path)
      content = File.read(source_path)
      Metadata.new(source_path, content)
    end

    def self.build(metadata)
      Adoc.new(metadata, TEMPLATE)
    end
  end
end
