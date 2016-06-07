require 'treetop'
require 'pp'

require_relative 'interpreter/trivial.rb'
require_relative 'interpreter/expression.rb'
require_relative 'interpreter/grammar.rb'

base_path = File.expand_path(File.dirname(__FILE__))
Treetop.load(File.join(base_path, 'grammars/trivial'))
Treetop.load(File.join(base_path, 'grammars/expression'))
Treetop.load(File.join(base_path, 'grammars/parser'))


class Interpreter
  def self.count_nodes(ast)
    unless ast.elements
      return 1
    end

    cnt = 0
    ast.elements.each do |e|
      cnt += count_nodes(e)
    end

    1 + cnt
  end

  def self.tree_cleanup(ast)
    unless ast.elements
      return
    end

    # string value will be interpreted in 'Types::String' so child nodes are redundant
    if ast.class.to_s == 'Types::String'
      ast.elements.clear
      return
    end

    to_delete = []

    rex = /[\s\n\t]+/

    ast.elements.each do |e|
      if ['', ' ', '(', ')', "\n"].include? e.text_value or (!rex.match(e.text_value).nil? and rex.match(e.text_value)[0] == e.text_value)
        to_delete.push(e) else tree_cleanup(e) end
    end

    to_delete.each do |e| ast.elements.delete(e) end
  end

  def self.interpret(code)
    parser = GrammarParser.new
    ast = parser.parse code

    result = []
    if ast.nil?
      result.push(parser.failure_reason)
    else
      begin
        pp ast
        print "cleanup--------------------------------"
        tree_cleanup(ast)
        pp ast

        context = {}
        ast.evaluate( context, result )

        pp 'Context: ', context
      rescue Exception => e
        result.push(e.message)
        pp e.backtrace.inspect
      end
    end

    result
  end
end
