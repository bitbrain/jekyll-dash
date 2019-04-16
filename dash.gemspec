# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "dash"
  spec.version       = "0.1.0"
  spec.authors       = ["Miguel Gonzalez Sanchez"]
  spec.email         = ["miguel-gonzalez@gmx.de"]

  spec.summary       = "A dark UI theme for Jekyll, inspired by Dash UI for Atom."
  spec.homepage      = "https://bitbrain.github.io/jekyll-dash"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|LICENSE|README)!i) }

  spec.add_runtime_dependency "jekyll", "~> 3.5"
  spec.add_runtime_dependency "jekyll-feed", "~> 0.9"
  spec.add_runtime_dependency "jekyll-seo-tag", "~> 2.1"
  spec.add_runtime_dependency "jekyll-paginate"
  spec.add_runtime_dependency "liquid-md5", "~> 0.0.3"

  spec.add_development_dependency "bundler", "~> 2.0.1"
  spec.add_development_dependency "rake", "~> 12.0"
end
