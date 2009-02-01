module RGitHook
  class TestSuite < Plugin

    module RunnerMethods
      def test(commit)
        properties = {}
        in_temp_commit(commit) do |new_repo|
          # Some hacks to migrate rails app if found.
          if File.file?('./config/environment.rb')
            properties['db:migrate'] = rake('db:migrate')
            properties['db:test:prepare'] = rake('db:test:prepare')
          end  
          properties['spec'] = test_spec(repo) if File.directory? File.join(repo.working_dir,'spec')
          properties['cucumber'] = test_cucumber(repo) if File.directory? File.join(repo.working_dir,'features')
          properties['test_unit'] = test_unit(repo) if File.directory? File.join(repo.working_dir,'test')
        end
        properties["status"] = %w(spec cucumber test_unit).map{|t|properties[t][1].exitstatus}.max
        commit.properties = properties
      end

      def test_spec(repo)
        [%x(spec `find spec/ -name '*.rb'`),$?]
      end

      def test_cucumber(repo)
        [%x(cucumber -f html features/),$?]
      end

      def test_unit(repo)
        [%x(testrb `find test -name '*.rb'`),$?]
      end
    end
  end
end