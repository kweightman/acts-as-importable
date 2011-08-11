# See http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/212639
# And http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/210633 for alternative [:id] notation
class ActiveRecord::Base
  alias_method :id__, :id if method_defined? :id
end
