module Helpers
  module Cubrid
    def resource_for(hash)
	    Class.new do
	      hash.each_pair do |key,value|
	        define_method(key) { value }
	      end
	    end.new
	  end
  end
end
