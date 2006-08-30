require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'
require 'lib/rubicus'

PKG_NAME = "rubicus"
PKG_VERSION   = Rubicus::VERSION
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"
PKG_FILES = FileList[
  '[A-Z]*',
  'lib/**/*.rb',
  'test/**/*.rb'
]

desc "Deploy docs to RubyForge" 
task :rdoc_deploy => [:rdoc] do
  dirs = %w{doc}
  onserver = "poogle@rubyforge.org:/var/www/gforge-projects/rubicus" 
  dirs.each do | dir|
    `scp -r "#{`pwd`.chomp}/#{dir}" "#{onserver}"`
  end
end

# Genereate the RDoc documentation
Rake::RDocTask.new { |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = "Rubicus - Graphing Library for Ruby using the ploticus backend."
  rdoc.rdoc_files.include("README", "CHANGELOG", "MIT-LICENSE")
  rdoc.rdoc_files.include("lib/rubicus.rb")
  rdoc.rdoc_files.include("lib/rubicus/*.rb")
  rdoc.rdoc_files.include("lib/rubicus/layers/*.rb")
}

spec = Gem::Specification.new do |s|
  s.name = PKG_NAME
  s.version = PKG_VERSION
  s.author = "Jonathan Younger" 
  s.email = "jonathan@daikini.com"
  s.homepage = "http://rubicus.rubyforge.org"
  s.summary = "Graphing library for Ruby using the ploticus backend."
  s.description = "Rubicus is a pure Ruby wrapper around the ploticus http://ploticus.sourceforge.net graphing library."
  s.files = PKG_FILES.to_a
  s.has_rdoc = false
  s.rubyforge_project = "rubicus"
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

task :verify_user do
  raise "RUBYFORGE_USER environment variable not set!" unless ENV['RUBYFORGE_USER']
end

task :verify_password do
  raise "RUBYFORGE_PASSWORD environment variable not set!" unless ENV['RUBYFORGE_PASSWORD']
end

desc "Publish gem+tgz+zip on RubyForge. You must make sure lib/version.rb is aligned with the CHANGELOG file"
task :publish_packages => [:verify_user, :verify_password, :package] do
  require 'meta_project'
  require 'rake/contrib/xforge'
  release_files = FileList[
    "pkg/#{PKG_FILE_NAME}.gem",
    "pkg/#{PKG_FILE_NAME}.tgz",
    "pkg/#{PKG_FILE_NAME}.zip",
    "pkg/#{PKG_FILE_NAME}.gem.md5",
    "pkg/#{PKG_FILE_NAME}.tgz.md5",
    "pkg/#{PKG_FILE_NAME}.zip.md5"
  ]

  Rake::XForge::Release.new(MetaProject::Project::XForge::RubyForge.new(PKG_NAME)) do |xf|
    # Never hardcode user name and password in the Rakefile!
    xf.user_name = ENV['RUBYFORGE_USER']
    xf.password = ENV['RUBYFORGE_PASSWORD']
    xf.files = release_files.to_a
    xf.release_name = "Rubicus #{PKG_VERSION}"
  end
end