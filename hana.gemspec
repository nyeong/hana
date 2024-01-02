Gem::Specification.new do |s|
  s.name        = 'hana'
  s.version     = '0.0.2'
  s.summary     = "A compiler for hanassig"
  s.description = "Compile asciidoc files into blog"
  s.authors     = ["An Nyeong"]
  s.email       = 'me@annyeong.me'
  s.homepage    = 'https://github.com/nyeong/hana'

  s.files       = Dir['Gemfile', 'hana.gemspec', 'lib/**/*.rb', 'templates/**/*.erb', 'bin/**/*', 'static/**/*']
  s.executables << 'hana'
  s.add_runtime_dependency 'asciidoctor', '~> 2.0.0'
  s.add_runtime_dependency 'fiddle', '~> 1.1'
  s.add_runtime_dependency 'rouge', '~> 4.2.0'
end

