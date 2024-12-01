# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "lukasz_granica_homepage"
  spec.version       = "1.1.1"
  spec.authors       = ["Łukasz Granica"]
  spec.email         = ["granica.luaksz@gmail.com"]

  spec.summary       = "Hey there, and welcome to a place for all passionate developers who live and breathe code. Think of it as a place where we chat about tech mysteries, exchange ideas, and maybe even figure out how to debug the mysteries of life (or at least .NET!)."
  spec.homepage      = "graniluk.github.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f|
    f.match(%r!^((_(includes|layouts|sass|(data\/(locales|origin)))|assets)\/|README|LICENSE)!i)
  }

  spec.metadata = {
    "homepage_uri"      => "https://cotes2020.github.io/chirpy-demo",
    "source_code_uri"   => "https://github.com/GraniLuk/graniluk.github.io",
    "wiki_uri"          => "https://github.com/cotes2020/jekyll-theme-chirpy/wiki",
    "plugin_type"       => "theme"
  }

  spec.required_ruby_version = "~> 3.1"

  spec.add_runtime_dependency "jekyll", "~> 4.3"
  spec.add_runtime_dependency "jekyll-paginate", "~> 1.1"
  spec.add_runtime_dependency "jekyll-redirect-from", "~> 0.16"
  spec.add_runtime_dependency "jekyll-seo-tag", "~> 2.8"
  spec.add_runtime_dependency "jekyll-archives", "~> 2.2"
  spec.add_runtime_dependency "jekyll-sitemap", "~> 1.4"
  spec.add_runtime_dependency "jekyll-include-cache", "~> 0.2"

end
