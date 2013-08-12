module ActiveRecord
  module With
    module QueryMethods
      def with!(with_values)
        @values[:with] = (@values[:with] || {}).merge(with_values)
        self
      end
      
      def with(with_values)
        spawn.with!(with_values)
      end
    end
  end
  module With
    module Querying
      delegate :with, :with!, to: :all
    end
  end
end

ActiveRecord::Relation.class_eval do
  include ActiveRecord::With::QueryMethods
end

ActiveRecord::Base.class_eval do
  extend ActiveRecord::With::Querying
end