require 'rubygems'
require 'kconv'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s| 
  s.name = "StataTableParser"
  s.version = "0.0.5"
  s.author = "Raul Jara"
  s.email = "raul.c.jara@gmail.com"
  s.platform = Gem::Platform::RUBY
  s.summary = "Patches to the object model."
  s.files = FileList["{bin,lib}/*"].to_a
  s.require_path = "lib"
  s.test_files = FileList["{test,TestTables}/*"].to_a
  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
end
 
Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_tar = true 
end

task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
    puts "generated latest version"
end
