require 'cupid/response/object'

class Cupid
  module Response
    class DataFolder < Object
      ALL = []

      attr_reader :parent, :children
      fields :parent_data, :name

      def self.new(data)
        find(data[:id]) || super
      end

      def self.find(id)
        ALL.find {|it| it.id == id }
      end

      def initialize(data)
        super
        assign_children
        extract_parent
        add_to_identity_map
      end

      def root?
        not parent
      end

      private

      def assign_children
        @children = ALL.select {|it| it.parent == self }
      end

      def extract_parent
        if parent_data
          create_parent
          attach_to_parent
        end
      end

      def add_to_identity_map
        ALL << self
      end

      def create_parent
        @parent = self.class.new parent_data
      end

      def attach_to_parent
        parent.children << self
      end
    end
  end
end
