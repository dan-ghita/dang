module Expression
  class Main < Treetop::Runtime::SyntaxNode
    def evaluate(context, result)
      elements.each { |node| node.elements[0].evaluate(context, result).to_s }
    end
  end

  class LineComment < Treetop::Runtime::SyntaxNode
    def evaluate(context, result)
      ''
    end
  end

  class FunctionBodyElement < Treetop::Runtime::SyntaxNode
  end

  class FunctionDeclaration < Treetop::Runtime::SyntaxNode
    def evaluate(context, result)
      # fun
      function_name = elements[1].text_value

      # does
      function_body = elements[3].elements[0]

      # with
      parameters = []
      unless elements[5].text_value == 'none'
        parameters = elements[5].evaluate(context, result)
      end

      context[function_name] = [function_body, function_body.class.to_s, parameters]
    end
  end

  class FunctionBody < Treetop::Runtime::SyntaxNode
    def self.is_return_statement(element)
      element.class.to_s == 'Expression::Return'
    end

    def match_parameters(context, call_parameters, function_parameters)
      raise "Expected #{function_parameters.length} parameters but found #{call_parameters.length}" \
      unless function_parameters.length == call_parameters.length

      function_parameters.zip(call_parameters).each { |pair| context[pair[0]] = [pair[1], pair[1].class.to_s] }
    end

    def evaluate(context, result, call_parameters, function_parameters)
      current_context = context.clone

      match_parameters(current_context, call_parameters, function_parameters)

      if FunctionBody.is_return_statement elements[0]
        if elements[0].elements.size == 1
          return
        else
          return elements[0].elements[1].elements[0].evaluate(current_context, result)
        end
      else
        should_return, return_value = elements[0].evaluate(current_context, result)
        if should_return == true
          if return_value
            return return_value
          else
            return
          end
        end
      end

      unless elements[1].nil?
        elements[1].elements.each { |node|
          if FunctionBody.is_return_statement node.elements[0]
            if node.elements[0].elements.size == 1
              return
            else
              return node.elements[0].elements[1].elements[0].evaluate(current_context, result)
            end
          else
            should_return, return_value = node.elements[0].evaluate(current_context, result)
            if should_return == true
              if return_value
                return return_value
              else
                return
              end
            end
          end
        }
      end
    end
  end

  class FunctionCall < Treetop::Runtime::SyntaxNode
    def try_system_functions(context, result, function_name, parameters)
      if function_name == 'print'
        output_string = ''
        parameters.each { |parameter|
          output = parameter.is_a?(Treetop::Runtime::SyntaxNode) ? parameter.evaluate(context, result) : parameter
          if output_string != ''
            output_string += ' '
          end
          output_string += output.to_s
        }
        output_string.gsub!('"', '')
        result.push output_string
        return true
      end
      false
    end

    def evaluate(context, result)
      function_name = elements[0].text_value

      parameters = []
      unless elements[1].nil?
        parameters = elements[1].evaluate(context, result)
      end

      if try_system_functions(context, result, function_name, parameters)
        return
      end

      if context.has_key? function_name
        raise "[x] identifier #{function_name} is not defined as a function" unless context[function_name][1] == 'Expression::FunctionBody'
        context[function_name][0].evaluate(context, result, parameters, context[function_name][2])
      else
        raise "[x] identifier #{function_name} is not defined in the current context"
      end
    end
  end

  class ChainedElement < Treetop::Runtime::SyntaxNode
    def evaluate(context, result)
      if FunctionBody.is_return_statement elements[0]
        if elements[0].elements.size == 1
          return true, nil
        else
          return true, elements[0].elements[1].elements[0].evaluate(context, result)
        end
      else
        should_return, return_value = elements[0].evaluate(context, result)
        if should_return
          return should_return, return_value
        end
      end

      unless elements[1].nil?
        elements[1].elements.each { |node|
          node = node.elements[0]
          if FunctionBody.is_return_statement node
            if node.elements.size == 1
              return true, nil
            else
              return true, node.elements[1].elements[0].evaluate(context, result)
            end
          else
            should_return, return_value = node.evaluate(context, result)
            if should_return
              return should_return, return_value
            end
          end
        }
      end
      return false, nil
    end
  end

  class MethodCall < Treetop::Runtime::SyntaxNode
    def try_call_method(context, object_name, object, method_name, parameters)
      if object[1] == 'Array'
        if method_name == 'append'
          parameters.each { |parameter| object[0].push parameter }
        elsif method_name == 'delete'
          parameters.each { |parameter| object[0].delete parameter }
        else
          return false
        end
      else
        return false
      end

      context[object_name] = object
      true
    end

    def evaluate(context, result)
      object_name = elements[0].text_value
      if context.has_key? object_name
        object = context[object_name]
        method = elements[2]
        method_name = method.elements[0].text_value

        parameters = []
        unless elements[1].nil?
          parameters = method.elements[1].evaluate(context, result)
        end

        if try_call_method(context, object_name, object, method_name, parameters)
          return
        else
          raise "[x] Method #{method_name} can't be called for object #{object_name}(#{object[1]})"
        end
      else
        raise "[x] identifier #{object_name} is not defined in the current context"
      end
    end
  end
end