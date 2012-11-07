Gem::Specification.new do |s|
  s.name = "rubicus"
  s.version = "0.1.1"
  s.platform = Gem::Platform::RUBY
  s.authors = ["Jonathan Younger"]
  s.email = ["jonathan@daikini.com"]
  s.homepage = "https://github.com/daikini/rubicus"
  s.summary = "Graphing library for Ruby using the ploticus backend."
  s.description = "Rubicus is a pure Ruby wrapper around the ploticus http://ploticus.sourceforge.net graphing library."
  s.files = Dir["{lib}/**/*.rb", "MIT-LICENSE", "CHANGES", "README"]
  s.has_rdoc = false
  s.rubyforge_project = s.name
end
