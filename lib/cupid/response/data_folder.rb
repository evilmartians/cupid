require 'cupid/response/object'

class Cupid
  module Response
    class DataFolder < Object
      ALL = []

      attr_reader :parent, :children
      fields :parent_folder, :name

      def self.new(data)
        find(data[:id]) || super
      end

      def self.find(id)
        ALL.find {|it| it.id == id }
      end

      # TODO: refactor
      def initialize(data)
        super
        @children = ALL.select {|it| it.parent == self }
        parent.children << self if parent
        ALL << self
      end

      def parent
        @parent ||= begin
          if parent_folder and parent_folder[:id] != '0'
            self.class.new parent_folder
          end
        end
      end
    end
  end
end
