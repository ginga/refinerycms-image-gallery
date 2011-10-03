# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "refinerycms-image-gallery"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Vinicius Zago"]
  s.date = "2011-10-03"
  s.description = "Image Gallery for RefineryCMS."
  s.email = "mvinicius.zago@gmail.com"
  s.executables = ["refinerycms_image_gallery"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "bin/refinerycms_image_gallery",
    "lib/refinerycms-image-gallery.rb",
    "lib/templates/javascripts/coffeescripts/gallery.coffee",
    "lib/templates/javascripts/gallery.js",
    "lib/templates/javascripts/refinery/admin.js",
    "lib/templates/migration.rb",
    "lib/templates/models/model.rb",
    "lib/templates/stylesheets/gallery.css",
    "lib/templates/views/image.html.erb",
    "lib/templates/views/images.html.erb",
    "lib/templates/views/images_field.html.erb",
    "refinerycms-image-gallery.gemspec",
    "test/helper.rb",
    "test/test_refinerycms-image-gallery.rb"
  ]
  s.homepage = "http://github.com/ginga/refinerycms-image-gallery"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Image Gallery for RefineryCMS."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

