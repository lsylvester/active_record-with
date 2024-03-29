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
      
      def build_arel
        arel = super
        build_with(arel)
        arel
      end
      
      def build_with(arel)
        return arel unless @values[:with]
        arel.with @values[:with].map{ |name, relation| Arel::Nodes::As.new(Arel::Table.new(name), relation.arel) }
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