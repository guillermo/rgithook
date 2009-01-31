# #require File.join(File.dirname(__FILE__),'spec','test_result.rb')
#
# module RGitHook
#   class Spec < Plugin
#
#
#
#     def spec(rep)
#       rep ||= repo
#       raise Exception, 'It is imposible to test without working dir. No bare repo' if rep.bare
#       rep.working_dir
#
#     end
#   end
# end
#

module RGitHook
   class TestSuite < Plugin

      module RunnerMethods
         def test(commit)
            in_temp_commit(commit.id) do |new_repo|
               commit.properties['db:migrate'] = rake('db:migrate')
               commit.properties['db:test:prepare'] = rake('db:test:prepare')
               commit.properties['spec'] = test_spec(repo) if File.directory? File.join(dir,'spec')
               commit.properties['cucumber'] = test_cucumber(repo) if File.directory? File.join(dir,'features')
               #test_unit(repo) if File.directory? File.join(dir,'')
            end
         end

         def test_spec
            %x(spec -f e spec/)
         end

         def test_cucumber(repo)
            %x(cucumber -f html features/)
         end
      end
   end
end
