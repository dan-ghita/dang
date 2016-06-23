module Types
  class Integer < Treetop::Runtime::SyntaxNode
    def evaluate(context, result)
      text_value.to_i
    end
  end

  class Float < Treetop::Runtime::SyntaxNode
    def evaluate(context, result)
      text_value.to_f
    end
  end

  class String < Treetop::Runtime::SyntaxNode
    def evaluate(context, result)
      # text_value.gsub('"', '')
      text_value
    end
  end

  class Bool < Treetop::Runtime::SyntaxNode
    def evaluate(context, result)
      eval text_value
    end
  end

  class Array < Treetop::Runtime::SyntaxNode
    def evaluate(context, result)
      eval text_value
    end
  end

  class ArrayAccessor < Treetop::Runtime::SyntaxNode
    def evaluate(context, result)
      array_name = elements[0].text_value
      index = elements[2].evaluate(context, result)

      if context.has_key? array_name
        raise "[x] identifier #{array_name} is not of type Array/String but of type #{context[array_name][1]}" \
        unless %w(Array String).include? context[array_name][1]

        array = context[array_name][0]
      else
        raise "[x] identifier #{array_name} is not defined in the current context"
      end

      if index < 0 or index >= array.length
        raise "[x] index #{index} is out of bounds for array #{array_name}"
      end

      # string contains leading "
      res = context[array_name][1] == 'String' ? '"' + array[index + 1] + '"' : array[index]

      if elements.length > 4
        elements[4].elements.each do |node|
          index = node.elements[1].evaluate(context, result)

          raise "[x] element #{res} is not of type Array/String but of type #{res.class.to_s}" \
        unless %w(Array String).include? res.class.to_s

          if index < 0 or index >= res.length
            raise "[x] index #{index} is out of bounds for array #{res}"
          end

          res = res[index]
        end
      end

      res
    end
  end

  class Range < Array
    def evaluate(context, result)
      first = elements[0].evaluate(context, result)
      last = elements[2].evaluate(context, result)
      (first..last).to_a
    end
  end

  class Identifier < Treetop::Runtime::SyntaxNode
    def evaluate(context, result)
      raise "[x] Identifier #{text_value} is not declared in this context" unless context.has_key? text_value
      context[text_value][0]
    end
  end

  class FunctionCallParameters < Treetop::Runtime::SyntaxNode
    def evaluate(context, result)
      parameters = []
      parameters.push elements[0].evaluate(context, result)

      unless elements[1].nil?
        elements[1].elements.each { |node| parameters.push node.elements[1].evaluate(context, result) }
      end

      parameters
    end
  end

  class Parameters < Treetop::Runtime::SyntaxNode
    def evaluate(context, result)
      parameters = []
      parameters.push elements[0].text_value
      unless elements[1].nil?
        elements[1].elements.each { |node| parameters.push node.elements[1].text_value }
      end

      parameters
    end
  end
end