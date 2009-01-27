require 'test/unit'
require File.dirname(__FILE__) + '/../lib/rgithook'

require 'tmpdir'
require 'tempfile'
require 'fileutils'

require 'mocha'

require 'ruby-debug'

require File.dirname(__FILE__) + '/fixtures/sample_plugin'

def mock_repo
  repo = mock('grit_repo')
  repo.stubs(:'is_a?').with(::Grit::Repo).returns(true)    
  repo
end

