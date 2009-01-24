require 'erb'

module ToHtml
  def to_html
    filename = self.class.to_s.gsub(/.*::/,'').downcase+'.html.erb'
    template = File.join(File.dirname(__FILE__),'html',filename)
  end
end



module ToHtml
  def to_html
    filename = self.class.to_s.gsub(/.*::/,'').downcase+'.html.erb'
    template = File.join(File.dirname(__FILE__),'html',filename)
    ::ERB.new(File.read(template)).result(binding)
  end
end

class ::Grit::Commit
  include ToHtml
end

class ::Grit::Diff
  include ToHtml
end

class Object
  def to_html
    to_s
  end
end

class Array
  def to_html
    self.map{|e| e.to_html}.join("\n")
  end
end

class String
  HTML_ESCAPE = { '&'=>'&amp;', '<'=>'&lt;', '>'=>'&gt;', '"'=>'&quot;', "'"=>'&#039;', }

  # Returns a copy of <tt>text</tt> with ampersands, angle brackets and quotes
  # escaped into HTML entities.
  def html_escape
      self.gsub(/[\"><&]/) { |s| HTML_ESCAPE[s] }
  end

  def color_diff
      self.gsub( /^(\+[^+].*)$/, '<ins style="background:#dfd;text-decoration:none;padding:0 10px;">\1</ins>').
      gsub( /^(\-[^-].*)$/, '<del style="background:#fdd;text-decoration:none;padding:0 10px;">\1</del>')
  end
end
