module Expression
  class Expression < Treetop::Runtime::SyntaxNode
    def evaluate( context, result )
      operand1 = elements[0].evaluate( context, result )
      operator = elements[1].text_value
      operand2 = elements[2].evaluate( context, result )

      if operand1.class != operand2.class
        raise "[x] Can't match #{operand1.class} with #{operand2.class}"
      else
        eval "#{operand1} #{operator} #{operand2}"
      end
    end
  end

  class BooleanExpression < Treetop::Runtime::SyntaxNode
    def evaluate( context, result )
      operand1 = elements[0].evaluate( context, result )
      operator = elements[1].text_value
      operand2 = elements[2].evaluate( context, result )

      eval "#{operand1} #{operator} #{operand2}"
    end
  end

  class Body < Treetop::Runtime::SyntaxNode
    def evaluate( context, result )
      elements[1].evaluate( context, result )
    end
  end

  class Term < Treetop::Runtime::SyntaxNode
    def evaluate( context, result )
      operand1 = elements[0].evaluate( context, result )
      operator = elements[1].text_value
      operand2 = elements[2].evaluate( context, result )

      if operand1.class != operand2.class
        raise "[x] Can't match #{operand1.class} with #{operand2.class}"
      else
        eval "#{operand1} #{operator} #{operand2}"
        end
    end
  end

  class Factor < Treetop::Runtime::SyntaxNode
    def evaluate( context, result )
      elements[0].evaluate( context, result )
    end
  end

  class Assignment < Treetop::Runtime::SyntaxNode
    def evaluate( context, result )
      value = elements[2].is_a?(Treetop::Runtime::SyntaxNode) ? elements[2].evaluate( context, result ) : elements[2]
      context[elements[0].text_value] = [value, value.class.to_s]
    end
  end

  class ArrayAssignment < Treetop::Runtime::SyntaxNode
    def evaluate( context, result )
      value = elements[2].is_a?(Treetop::Runtime::SyntaxNode) ? elements[2].evaluate( context, result ) : elements[2]
      array_name = elements[0].elements[0].text_value
      index = elements[0].elements[2].evaluate( context, result )

      if context.has_key? array_name
        raise "[x] identifier #{array_name} is not of type array but of type #{context[array_name][1]}" unless context[array_name][1] == 'Array'
        array = context[array_name][0]
      else
        raise "[x] identifier #{array_name} is not defined in the current context"
      end

      if index < 0 or index >= array.length
        raise "[x] index #{index} is out of bounds for array #{array_name}"
      end

      array[index] = value
      context[array_name][0] = array
    end
  end

  class Declaration < Treetop::Runtime::SyntaxNode
    def evaluate( context, result )
      value = elements[3].is_a?(Treetop::Runtime::SyntaxNode) ? elements[3].evaluate( context, result ) : elements[3]
      context[elements[1].text_value] = [value, value.class.to_s]
    end
  end

  class BooleanOperator < Treetop::Runtime::SyntaxNode
    def evaluate( context, result )
      text_value.to_s
    end
  end

  class ForLoop < Treetop::Runtime::SyntaxNode
    def evaluate( context, result )
      # select
      identifier = elements[1].text_value
      if context.has_key? identifier
        raise "[x] Key #{identifier} is already defined"
        return
      end
      # from
      array = elements[3].evaluate( context, result )

      if elements[4].text_value.start_with?('where')
        has_filter = true
        # where condition
        condition = elements[4].elements[0].elements[1]
        # do
        body = elements[6]
      else
        has_filter = false
        # do
        body = elements[5]
      end

      array.each { |element|
        context[identifier] = [element, element.class.to_s]
        unless has_filter and !condition.evaluate( context, result )
          body.evaluate( context, result )
        end
      }
      context.delete(identifier)
    end
  end

  class IfStatement < Treetop::Runtime::SyntaxNode
    def evaluate( context, result )
      condition = elements[1]
      if condition.evaluate( context, result )
        elements[3].evaluate( context, result )
      elsif elements[4].text_value != 'end'
        elements[4].elements[1].evaluate( context, result )
      end
    end
  end

  class Return < Treetop::Runtime::SyntaxNode
    def evaluate
    end
  end
end