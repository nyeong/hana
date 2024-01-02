Gem::Specification.new do |s|
  s.name        = 'hana'
  s.version     = '0.0.1'
  s.summary     = "A compiler for hanassig"
  s.description = "Compile asciidoc files into blog"
  s.authors     = ["An Nyeong"]
  s.email       = 'me@annyeong.me'
  s.homepage    = 'https://github.com/nyeong/hana'
  begin
    files = (result = `git ls-files -z`.split ?\0).empty? ? Dir['**/*'] : result
  rescue
    files = Dir['**/*']
  end
  s.files       = files.grep %r/^(?:(?:lib)\/.+|LICENSE|(?:CHANGELOG|README(?:-\w+)?)\.adoc|\.yardopts|#{s.name}\.gemspec)$/
  s.add_development_dependency 'asciidoctor', '~> 2.0.0'
  s.add_development_dependency 'fiddle', '~> 1.1'
  s.add_development_dependency 'rouge', '~> 4.2.0'
end

