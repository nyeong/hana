# frozen_string_literal: true

require 'fileutils'

# Lint or Build adoc files
module Hana
  require_relative './hana/build'
  require_relative './hana/lint'

  def self.read_from_dir(source_path)
    Dir.children(source_path)
       .filter { |filename| filename.end_with?('.adoc') }
       .map { |filename| File.join(source_path, filename) }
       .map { |absolute_path| Build.read(absolute_path) }
  end

  def self.lint(source_path)
    metatdata = read_from_dir(source_path)

    slug_title_map = metatdata.map { |metadata| [metadata.slug, metadata.title] }.to_h

    metatdata.map { |metadata| metadata.lint(slug_title_map) }
             .each { |metadata| File.write(metadata.absolute_path, metadata.content) }
  end

  def self.build(source_path, dest_directory)
    read_from_dir(source_path)
      .map { |metadata| Build.build(metadata) }
      .each { |adoc| adoc.write!(dest_directory) }
    FileUtils.cp_r(File.join(File.dirname(__FILE__), '../static'), File.join(dest_directory, 'static'))
  end
end
