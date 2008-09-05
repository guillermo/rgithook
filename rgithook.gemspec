Gem::Specification.new do |s|
  s.name = %q{rgithook}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["=Guillermo \303\201lvarez"]
  s.cert_chain = ["/home/guillermo/.gem/gem-public_cert.pem"]
  s.date = %q{2008-09-05}
  s.description = %q{description of gem}
  s.email = ["=guillermo@cientifico.net"]
  s.extra_rdoc_files = ["History.txt", "License.txt", "Manifest.txt", "PostInstall.txt"]
  s.files = ["History.txt", "License.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "lib/rgithook.rb", "lib/rgithook/version.rb", "lib/rgithook/html.rb", "lib/rgithook/githook.rb", "test/test_helper.rb", "test/test_rgithook.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://rgithook.rubyforge.org}
  s.post_install_message = %q{
For more information on rgithook, see http://rgithook.rubyforge.org

NOTE: Change this information in PostInstall.txt 
You can also delete it if you don't want it.


}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rgithook}
  s.rubygems_version = %q{1.2.0}
  s.signing_key = %q{/home/guillermo/.gem/gem-private_key.pem}
  s.summary = %q{description of gem}
  s.test_files = ["test/test_helper.rb", "test/test_rgithook.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_development_dependency(%q<hoe>, [">= 1.7.0"])
    else
      s.add_dependency(%q<hoe>, [">= 1.7.0"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.7.0"])
  end
end