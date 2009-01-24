require 'test/unit'
require File.dirname(__FILE__) + '/../lib/rgithook'
require 'tmpdir'
require 'tempfile'
require 'fileutils'
require 'mocha'
require 'ruby-debug'

def mock_repo
  repo = mock('grit_repo')
  repo.stubs(:'is_a?').with(::Grit::Repo).returns(true)    
  repo
end

# 
# def in_temp_dir(&block)
#   raise LocalJumpError, 'no block given' unless block_given?
#   
#   tmpdir = File.join(Dir.tmpdir,'rgithook',Time.now.usec.to_s,rand.to_s[2..-1])
#   FileUtils.mkdir_p(tmpdir)
# 
#   ret_val = yield tmpdir
# 
#   FileUtils.remove_dir(tmpdir)
#   ret_val
# end
# 
# def in_temp_repo(&block)
#   raise LocalJumpError, 'no block given' unless block_given?
#   ret_val = nil
#   in_temp_dir do |tempdir|
#     %x( export GIT_WORK_TREE=#{tempdir} ; export GIT_DIR=$GIT_WORK_TREE/.git ; cd $GIT_WIRK_TREE ; touch 'asdf' ; git init && git add . && git commit -a -m 'initial import'; touch 'asdf2' ; git add . && git commit -a -m 'second commit')
#     ret_val = yield Grit::Repo.new(tempdir)
#   end
#   ret_val
# end
# 
# def in_temp_cloned_bare_repo(repo,&block)
#   raise LocalJumpError, 'no block given' unless block_given?
#   ret_val = nil
#   in_temp_dir do |tempdir|
#     dest_dir = File.join(tempdir,'bare.git')
#     %x(cd #{tempdir} ; git clone --bare #{repo.bare ? repo.working_path : repo.path } #{dest_dir})
#     ret_val = yield Grit::Repo.new(dest_dir)
#   end
#   ret_val
# end
# 
# def in_temp_bare_repo(&block)
#   raise LocalJumpError, 'no block given' unless block_given?
#   ret_val = nil
#   in_temp_repo do |repo|
#     in_temp_cloned_bare_repo(repo) do |bare_repo|
#       ret_val = yield bare_repo
#     end
#   end
# end
#   
# def rgithook_command_path(opts)
#   File.join(File.dirname(__FILE__),'..','bin','rgithook ')+opts+' 2>&1 > /dev/null'
# end
