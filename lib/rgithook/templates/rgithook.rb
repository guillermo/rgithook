# RGitHook hooks_file
# To define a hook just type:
# 
#   on :hook_name do |hook_params|
#     ... Actions ... 
#   end
#
# Just simple.
#   
# There is a few factory-made plugins ready to use
#  * test (spec/cucumber/test::unit)
#  * db Persisten layer for commit properties.


# Used to check the commit log message of of a apply patch
on :applypatch_msg do |commit_message_path|
  puts "applypatch_msg"
  puts File.read(commit_message_path)
  return 0 # If return =! 0 commit is stopped
end

# Called every time you commit 
on :commit_msg do |commit_message_path|
  puts "The commit message is in #{commit_message_path}"
  # You can edit the commit_message
  return 0 # If return =! 0 commit is stopped
end

# Called when a commit is susescfully created
on :post_commit do
  puts "A commited was made"
end

# Called when a the current repo recive commits from external repository
# For example: A remote push
on :post_receive do |old_commit, new_commit, ref|
  
  repo.commits_between(old_commit,new_commit) do |commit|
    test(commit)
  end
    
  # These is the best hook to track changes in a repository
  # run test, deploy to staging, mail diffs, etc...
  return 0
end

on :post_update do
  return 0
end

# Called before commited a patch
on :pre_applypatch do
  return 0
end

# Called before a commit is made
on :pre_commit do
  # You can run tests here if you don't want to commit anything that make tests fail
  return 0
end


# Called before pre_rebase
on :pre_rebase do
  return 0
end

# Called to edit the commit message before commit
on :prepare_commit_msg do |commit_mesage_path|
  return 0
end

on :update do
  return 0
end
  
  
  
  
  
