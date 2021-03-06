lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tagrity/version"

Gem::Specification.new do |spec|
  spec.name          = "tagrity"
  spec.version       = Tagrity::VERSION
  spec.authors       = ["Adam P. Regasz-Rethy"]
  spec.email         = ["rethy.spud@gmail.com"]

  spec.summary       = %q{Update tags on file changes.}
  spec.description   = %q{Update your tags file when files change. tags files are used primarily with Vim as a navigation tool.}
  spec.homepage      = "https://github.com/RRethy/tagrity"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/RRethy/tagrity"
  spec.metadata["changelog_uri"] = "https://github.com/RRethy/tagrity/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor', '~> 0.20'
  spec.add_dependency 'listen', '~> 3.2.1'
  spec.add_dependency 'cli-ui', '~> 1.3.0'

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "ripper-tags", "~> 0.8.0"
  spec.add_development_dependency "pry", "~> 0.9.9"
end
