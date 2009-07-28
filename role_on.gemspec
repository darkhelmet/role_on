# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{role_on}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Daniel Huckstep"]
  s.date = %q{2009-07-28}
  s.email = %q{darkhelmet@darkhelmetlive.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.md",
     "Rakefile",
     "TODO",
     "VERSION",
     "generators/role_on/role_on_generator.rb",
     "generators/role_on/templates/app/models/role.rb",
     "generators/role_on/templates/db/migrate/migration.rb",
     "init.rb",
     "lib/role_on.rb",
     "role_on.gemspec"
  ]
  s.homepage = %q{http://github.com/darkhelmet/role_on}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Really simple roles}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
