class Cupid

  class FilterBase

    attr_reader :empty

    def &(other)
      return self if empty
      return other if other.empty
      Logical.new self, "AND", other
    end

    def |(other)
      return other if empty
      return self if other.empty
      Logical.new self, "OR", other
    end

  end

  class Logical < FilterBase

    def initialize(left, operator, right)
      @left = left
      @operator = operator
      @right = right
    end

    def to_hash(wrap=true)
      filter = {
        :left_operand => @left.to_hash(false),
        :logical_operator => @operator,
        :right_operand => @right.to_hash(false),
        :attributes! => {
          :left_operand => {
            "xsi:type" => @left.xsi_type
          },
          :right_operand => {
            "xsi:type" => @right.xsi_type
          }
        }
      }
      if wrap
        {
          :filter => filter,
          :attributes! => {
            :filter => {
              "xsi:type" => xsi_type
            }
          }
        }
      else
        filter
      end
    end

    def inspect
      "#{@left} #{@operator} #{@right}"
    end

    def to_s
      inspect
    end

    def xsi_type
      "ComplexFilterPart"
    end

  end

  class Filter < FilterBase

    class <<self

      def [](name)
        new name
      end

      def method_missing(name, *args, &blk)
        new name
      end

      def const_missing(name)
        new name
      end

    end

    def inspect
      op_repr = @operator
      op_repr = "==" if op_repr == "equals"
      op_repr = "=~" if op_repr == "like"
      "#{@field_name} #{op_repr} #{@value.inspect}"
    end

    def to_s
      inspect
    end

    def method_missing(name, *args, &blk)
      self.class::new "#{@field_name}.#{name}"
    end

    def initialize(field_name)
      @field_name = field_name
    end

    def like(value)
      @value = value
      @operator = "like"
      self
    end

    def equals(value)
      @value = value
      @operator = "equals"
      self
    end

    def in(value)
      raise ArgumentError.new "`in` filter requires Enumerable" unless value.is_a? Enumerable
      @empty = true if value.count == 0
      if value.count == 1
        equals value[0]
      else
        @value = value
        @operator = "IN"
        self
      end
    end

    def ==(value)
      equals value
    end

    def =~(value)
      if value.is_a? String
        like value
      elsif value.is_a? Enumerable
        send :in, value
      else
        raise ArgumentError.new "filter =~ arg should be String or Enumerable"
      end
    end

    def to_hash(wrap=true)
      return nil if empty
      filter = {
        :property => @field_name,
        :simple_operator => @operator,
        :value => @value
      }
      if wrap
        {
          :filter => filter,
          :attributes! => {
            :filter => {
              "xsi:type" => xsi_type
            }
          }
        }
      else
        filter
      end
    end

    def xsi_type
      "SimpleFilterPart"
    end

  end

end
