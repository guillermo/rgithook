class EmailPluginTest < Test::Unit::TestCase
   def test_test
     with_sample_rgithook do 
      in_runner "test(repo.commits[0])"
      assert @rgithook.repo.commits[0].properties.include? "spec"
      assert @rgithook.repo.commits[0].properties.include? "cucumber"
      assert @rgithook.repo.commits[0].properties.include? "spec"
      assert @rgithook.repo.commits[0].properties.include? "status"
      assert_equal @rgithook.repo.commits[0].properties["status"],  0
      
      
    end
   end
end
