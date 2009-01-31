# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rgithook}
  s.version = "3.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Guillermo \303\201lvarez"]
  s.cert_chain = ["/Users/guillermo/.rubygems/gem-public_cert.pem"]
  s.date = %q{2009-01-31}
  s.default_executable = %q{rgithook}
  s.description = %q{Ruby gem specify for git hooks.}
  s.email = %q{guillermo@cientifico.net}
  s.executables = ["rgithook"]
  s.extra_rdoc_files = ["bin/rgithook", "CHANGELOG", "lib/plugins/custom.rb", "lib/plugins/db.rb", "lib/plugins/email.rb", "lib/plugins/html/commit.html.erb", "lib/plugins/html/diff.html.erb", "lib/plugins/html.rb", "lib/plugins/rake.rb", "lib/plugins/spec/rgithook_formatter.rb", "lib/plugins/spec/spec_result.rb", "lib/plugins/temp.rb", "lib/plugins/test.rb", "lib/plugins/twitter.rb", "lib/rgithook/command_line.rb", "lib/rgithook/hook.rb", "lib/rgithook/plugin.rb", "lib/rgithook/rgithook.rb", "lib/rgithook/runner.rb", "lib/rgithook/templates/hook.rb", "lib/rgithook/templates/rgithook.rb", "lib/rgithook/test/unit.rb", "lib/rgithook.rb", "README.rdoc", "TODO.txt"]
  s.files = ["bin/rgithook", "CHANGELOG", "lib/plugins/custom.rb", "lib/plugins/db.rb", "lib/plugins/email.rb", "lib/plugins/html/commit.html.erb", "lib/plugins/html/diff.html.erb", "lib/plugins/html.rb", "lib/plugins/rake.rb", "lib/plugins/spec/rgithook_formatter.rb", "lib/plugins/spec/spec_result.rb", "lib/plugins/temp.rb", "lib/plugins/test.rb", "lib/plugins/twitter.rb", "lib/rgithook/command_line.rb", "lib/rgithook/hook.rb", "lib/rgithook/plugin.rb", "lib/rgithook/rgithook.rb", "lib/rgithook/runner.rb", "lib/rgithook/templates/hook.rb", "lib/rgithook/templates/rgithook.rb", "lib/rgithook/test/unit.rb", "lib/rgithook.rb", "Manifest", "Rakefile", "README.rdoc", "test/fixtures/sample_plugin.rb", "test/fixtures/sample_repo.zip", "test/integration/test_install.rb", "test/plugins/test_email.rb", "test/plugins/test_html.rb", "test/plugins/test_spec.rb", "test/test_helper.rb", "test/unit/test_command_line.rb", "test/unit/test_hook.rb", "test/unit/test_plugin.rb", "test/unit/test_rgithook.rb", "test/unit/test_runner.rb", "TODO.txt", "rgithook.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/guillermo/rgithook2}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Rgithook", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rgithook}
  s.rubygems_version = %q{1.3.1}
  s.signing_key = %q{/Users/guillermo/.rubygems/gem-private_key.pem}
  s.summary = %q{You can deploy updated code, restart the web server, run the tests, email the diff, etc... You can use a cron to pull or a githook to run when pushed to the repo.}
  s.test_files = ["test/integration/test_install.rb", "test/plugins/test_email.rb", "test/plugins/test_html.rb", "test/plugins/test_spec.rb", "test/test_helper.rb", "test/unit/test_command_line.rb", "test/unit/test_hook.rb", "test/unit/test_plugin.rb", "test/unit/test_rgithook.rb", "test/unit/test_runner.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mojombo-grit>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<mojombo-grit>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<mojombo-grit>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
