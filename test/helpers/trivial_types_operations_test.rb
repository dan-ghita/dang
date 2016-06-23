require 'test_helper'

class TrivialOperationsTest < ActiveSupport::TestCase
  test 'Float sum produces correct output' do
    code = 'a = 1.255
            b = 0.5
            c = a + b
            print(c)'

    result = Interpreter.interpret(code)
    assert_equal(['1.755'], result)
  end

  test 'Int and float sum produces correct output' do
    code = 'a = 1.255
            b = 3
            c = b + a
            print(c)'

    result = Interpreter.interpret(code)
    assert_equal(['4.255'], result)
  end

  test 'Float and int sum produces correct output' do
    code = 'a = 1.255
            b = 3
            c = a + b
            print(c)'

    result = Interpreter.interpret(code)
    assert_equal(['4.255'], result)
  end

  test 'Float operation subtraction produces correct output' do
    code = 'print(1 - 1.5, 1.5 - 1, 1.5 - 0.5)'

    result = Interpreter.interpret(code)
    assert_equal(['-0.5 0.5 1.0'], result)
  end

  test 'Float operation multiplication produces correct output' do
    code = 'print(1 * 1.3, 1.1 * 1, 1.5 * 0.6)'

    result = Interpreter.interpret(code)
    assert_equal(['1.3 1.1 0.8999999999999999'], result)
  end

  test 'Float operation division produces correct output' do
    code = 'print(1 / 1.3, 1.1 / 1, 1.5 / 0.6)'

    result = Interpreter.interpret(code)
    assert_equal(['0.7692307692307692 1.1 2.5'], result)
  end

  test 'Chained mul/div operation are executed in the proper order' do
    code = 'print(1.0 / 2 * 3 / 4 * 5 / 6)'

    result = Interpreter.interpret(code)
    assert_equal(['0.3125'], result)
  end

  test 'Chained sum/sub operation are executed in the proper order' do
    code = 'print(1.0 - 2 + 3 - 4 - 5 + 6)'

    result = Interpreter.interpret(code)
    assert_equal(['-1.0'], result)
  end

  test 'Parenthesised expression produces correct output' do
    code = 'c = (1.0/2) - (1.0/3) + (1.0/4) * (1.0/5) / (1.0/6)
            print(c)'

    result = Interpreter.interpret(code)
    assert_equal(['0.46666666666666673'], result)
  end

  test 'Complex float operation produces correct output' do
    code = 'c = 1 - 1.2 + (1.1 * 9 + 2.5 * 88 / 16 - 100.2) / 5
            print(c)'

    result = Interpreter.interpret(code)
    assert_equal(['-15.510000000000002'], result)
  end
end
