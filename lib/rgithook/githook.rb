module RGitHook

  # PostReceivePack es el pack que se recive al hacer un push
  # Un mismo pack puede tener actualizacioens para diferentes branches
  class PostReceivePack
    def initialize(string = nil)
      string ||= STDIN.read
      @heads, @updates = string.split("\n"), []
      @heads.each { |head| @updates << RefUpdate.new(head) }
      require 'rubygems'
      require 'tmail'
    end

    def to_html
      "<div class='post_receive_pack'>\n#{map{|e|e.to_html}.join}\n</div>"
    end

    def to_s
      text = "Se han recibido #{@heads.size} actualizaciones\n"
      each_with_index do |update,index| 
        text << format("ActualizaciÃ³n %d\n", index+1)
        text << update.to_s
        text << format("\n")
      end
      text
    end
    
    # Returns an Array of Strings naming refs
    def refs
      map {|update| update.ref}    
    end
    
    
    def each
      @updates.each {|u| yield u}
    end

    def each_with_index 
      @updates.each_with_index {|u| yield u}
    end
    
    def map
      @updates.map {|u| yield u}
    end
    
    def sendmail
      each do |refupdate|
        refupdate.sendmail
      end
    end
  end

  # Un RefUpdate es una coleciÃ³n de commits
  class RefUpdate
  
  
    attr_reader :ref
    def initialize(string)
      @rev_old, @rev_new, @ref = string.split(" ")
      commits = %x(git rev-list #{@rev_old}..#{@rev_new}).split
      @commits = commits.map {|c| Commit.new(c)}
    end
    
    def sendmail
      to = %x(git-config hooks.mailinglist).strip
      part = ::TMail::Mail.new
      part.set_content_type "text", "html"
      part.body = HTML_HEADER+to_html+HTML_FOOTER

      mail         = ::TMail::Mail.new
      mail.to      = to
      mail.from    = format("%s@%s",@ref.gsub("/","."),%x(hostname).strip)
      mail.subject = format("%s se actualizo",@ref)
      mail.body    = to_s
      mail.parts << part

      sendmail = IO.popen("/usr/sbin/sendmail #{to}", "w")
      sendmail.write mail.to_s
      sendmail.close
      mail.to_s
    end

    def to_s
      commits = map {|commit| commit.to_s}
      commits.join("\n")
    end
    
    def to_html
      html = ""
      html << "<div class='refupdate'>\n"
      html << "<h2>ActualizaciÃ³n de #{@ref}</h2>"
      if @commits.size > 1
        
        html << "<div class='summary'><ul>"
        @commits.each do |commit|
          html << format("<li class='summarycommit'>%s<br/><ul>",commit.message.split("\n")[0])
          commit.files.each do |file|
            html << format("<li class='file'><span>%s (<span class='insertions'>+%s</span>/<span class='deletions'>-%s</span>)</span></li>\n",file.name, file.ins.to_s, file.del.to_s)
          end
          html << "</ul></li>"
        end
        html << "</ul></div>\n"
      end
      html << "\n#{map {|c|c.to_html}.join}\n</div>\n"
      html
    end
    
  protected
    def each
      @commits.each {|c| yield c}
    end
    
    def map
      @commits.map {|c| yield c}
    end
    
  end
  
  class Helpers
    HTML_ESCAPE = { '&'=>'&amp;', '<'=>'&lt;', '>'=>'&gt;', '"'=>'&quot;', "'"=>'&#039;', }

    # Returns a copy of <tt>text</tt> with ampersands, angle brackets and quotes
    # escaped into HTML entities.
    def self.html_escape(text)
      text.to_s.gsub(/[\"><&]/) { |s| HTML_ESCAPE[s] }
    end
  end


  # Commit Identifica a un Ãºnico commit
  class Commit
    attr_reader :commit, :message, :author, :date, :files
    def initialize(commit)
      @commit = commit
      log     = %x(git-cat-file -p #{commit}).split("\n")

      @message = log[5..-1].join("\n")
      @author  = log[2].split(" ")[1..-3].join(" ")
      @date    = Time.at log[2].split(" ")[-2].to_i
      @files   = %x(git diff #{commit}^ #{commit} --numstat).split("\n").map {|f| f.split("\t")}.map do |f|
        diff = %x(git diff #{commit}^ #{commit} -- #{f[2]})
        File.new(f[2],f[0],f[1], diff )
      end
    end
    
    def to_s
      "#{@commit[0..6]}... #{@message.split("\n")[0]}."
    end
    
    def to_html
      html = ""
      html << "<div class='commit'>"
      html << "<dl>\n"
        html << "<dt>sha1</dt><dd class='sha1'>#{@commit}</dd>\n"
        html << "<dt>author</dt><dd class='author'>#{Helpers.html_escape(@author)}</dd>\n"
        html << "<dt>date</dt><dd class='date'>#{@date}</dd>\n"
        html << "<dt>message</dt><dd class='message'>\n\t#{Helpers.html_escape(@message)}\n\t</dd>\n"
      html << "</dl>"
      html << "<div class='diffs'>\n\t#{@files.map{ |diff| diff.to_html} }\n\t</div>\n"
      html << "</div>"
      html
    end
  end
  
  class File
    attr_reader :name, :ins, :del, :diff
    def initialize(filename,inserts,deletions,diff)
      @name, @ins, @del = filename,inserts,deletions
      @diff = diff.split("\n")[4..-1].join("\n")
    rescue NoMethodError
      # No se pudo generar el diff
    ensure
      @diff = "" if @diff.nil?
    end
    def to_s
      format("FILE: %s (+%s/-%s)\n%s",@name,@ins.to_s,@del.to_s,@diff)
    end
    def to_html
      html = "<div class='file'>"
      html << "<div class='filename'>#{@name}</div>"
      html << "<div class='insertions'>+#{@ins}</div>"
      html << "<div class='deletions'>-#{@del}</div>"
      diff = Helpers.html_escape(@diff)
      diff.gsub!( /^(\+[^+].*)$/, '<ins>\1</ins>')
      diff.gsub!( /^(\-[^-].*)$/, '<del>\1</del>')
      html << "<div class='diff'><pre>"+diff+"</pre></div>\n"
      html << "</div>\n"
    end  
  end
end
