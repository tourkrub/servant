lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "servant/version"

Gem::Specification.new do |spec| # rubocop:disable Metrics/BlockLength
  spec.name          = "servant"
  spec.license       = "MIT"
  spec.version       = Servant::VERSION
  spec.authors       = ["Sittitep Tosuwan"]
  spec.email         = ["sittitep.tos@tourkrub.co"]

  spec.summary       = "Servant"
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  # spec.homepage      = "https://google.com"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    # spec.metadata["homepage_uri"] = spec.homepage
    # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
    # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # spec.add_dependency "tty-box", "~> 0.3.0"
  # spec.add_dependency "tty-color", "~> 0.4"
  # spec.add_dependency "tty-command", "~> 0.8.0"
  # spec.add_dependency "tty-config", "~> 0.3.0"
  # spec.add_dependency "tty-cursor", "~> 0.6"
  # spec.add_dependency "tty-editor", "~> 0.5.0"
  # spec.add_dependency "tty-file", "~> 0.7.0"
  # spec.add_dependency "tty-font", "~> 0.2.0"
  # spec.add_dependency "tty-markdown", "~> 0.5.0"
  # spec.add_dependency "tty-pager", "~> 0.12.0"
  # spec.add_dependency "tty-pie", "~> 0.1.0"
  # spec.add_dependency "tty-platform", "~> 0.2.0"
  # spec.add_dependency "tty-progressbar", "~> 0.16.0"
  # spec.add_dependency "tty-prompt", "~> 0.18.0"
  # spec.add_dependency "tty-screen", "~> 0.6"
  # spec.add_dependency "tty-spinner", "~> 0.9.0"
  # spec.add_dependency "tty-table", "~> 0.10.0"
  # spec.add_dependency "tty-tree", "~> 0.2.0"
  # spec.add_dependency "tty-which", "~> 0.4"
  spec.add_dependency "dry-configurable", "~> 1.0.1"
  spec.add_dependency "httparty", "~> 0.21.0"
  spec.add_dependency "pastel", "~> 0.8.0"
  spec.add_dependency "redis", "< 6"
  spec.add_dependency "sidekiq", "< 7"
  spec.add_dependency "thor", ">= 1.2.1"
  spec.add_dependency "tourkrub-toolkit"

  spec.add_development_dependency "bump", "~> 0.10.0"
  spec.add_development_dependency "bundler", "~> 2.4.12"
  spec.add_development_dependency "byebug", "~> 11.1.3"
  spec.add_development_dependency "mock_redis", "~> 0.36.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "rubocop", "~> 1.50.2"
  spec.add_development_dependency "simplecov", "~> 0.22.0"
end
