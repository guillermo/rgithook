module RGitHook
  class TestSuite < Plugin

    module RunnerMethods
      def test(commit)
        commit.properties['testing'] = true
        commit.save_properties
        in_temp_commit(commit) do |new_repo|
          # Some hacks to migrate rails app if found.
          if File.file?('./config/environment.rb')
            commit.properties['db:migrate'] = rake('db:migrate')
            commit.properties['db:test:prepare'] = rake('db:test:prepare')
          end  
          commit.properties['spec'] = test_spec(repo) if File.directory? File.join(repo.working_dir,'spec')
          commit.properties['cucumber'] = test_cucumber(repo) if File.directory? File.join(repo.working_dir,'features')
          commit.properties['test_unit'] = test_unit(repo) if File.directory? File.join(repo.working_dir,'test')
        end
        commit.properties["status"] = %w(spec cucumber test_unit).map{|t|commit.properties[t][1].exitstatus}.max
      ensure
        commit.properties.delete 'testing'
        commit.save_properties
      end

      def test_spec(repo)
        [%x(spec spec/),$?]
      end

      def test_cucumber(repo)
        [%x(cucumber features/),$?]
      end

      def test_unit(repo)
        [%x(testrb `find test -name '*.rb'`),$?]
      end
    end
  end
end