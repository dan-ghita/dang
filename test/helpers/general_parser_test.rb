require 'test_helper'

class GeneralParserTest < ActiveSupport::TestCase
  test 'Float sum produces correct output' do
    code = 'when true then print() end'

    result = Interpreter.interpret(code)
    assert_equal([''], result)
  end

  test 'Print function prints all parameters on the same line' do
    code = 'print(1, 2, 3)'

    result = Interpreter.interpret(code)
    assert_equal(['1 2 3'], result)
  end
end
