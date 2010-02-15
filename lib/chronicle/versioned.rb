module Chronicle
  module Versioned
    def self.included(base)
      class << base
        def versioned?
          reflect_on_association(:versions) ? true : false
        end
      end
    end
  end
end