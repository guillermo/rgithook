

class EmailPluginTest < Test::Unit::TestCase
  
  def test_email
    in_runner "email('guillermo@cientifico.net','hello')"
  end
end