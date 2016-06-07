require 'test_helper'

class ConditionalBlockTest < ActiveSupport::TestCase
  test 'Conditional block executes all nested instructions' do
    code = 'when true then
              print(1)
              print(2)
              print(3)
              print(4)
              print(5)
            end '

    result = Interpreter.interpret(code)
    assert_equal(%w(1 2 3 4 5), result)
  end
end
