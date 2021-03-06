require 'test_helper'

class ProxyUtilTest < Test::Unit::TestCase
  class UtilClass; extend Proxy::Util; end

  def test_util_should_support_path
    assert Proxy::Util.instance_methods.include? :which
  end

  def test_util_shell_escape
    assert Proxy::Util.instance_methods.include? :escape_for_shell

    test_class = eval "class ProxyUtilTestHelper; include Proxy::Util; end"
    assert_equal test_class.new.escape_for_shell("; rm -rf"), '\;\ rm\ -rf'
    assert_equal test_class.new.escape_for_shell("vm.test.com,physical.test.com"), "vm.test.com,physical.test.com"
    assert_equal test_class.new.escape_for_shell("vm.test.com physical.test.com"), 'vm.test.com\ physical.test.com'
  end

  def test_commandtask_with_exit_0
    t = Proxy::Util::CommandTask.new('true').start
    assert_equal t.join, 0
  end

  def test_commandtask_as_array_with_exit_0
    t = Proxy::Util::CommandTask.new(["echo", "test"]).start
    assert_equal t.join, 0
  end

  def test_commandtask_with_input_and_exit_0
    t = Proxy::Util::CommandTask.new('cat', 'hello').start
    assert_equal t.join, 0
  end

  def test_commandtask_with_exit_1
    t = Proxy::Util::CommandTask.new('false').start
    assert_equal t.join, 1
  end

  def test_strict_encode64
    assert_equal "YWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWE=", UtilClass.strict_encode64("a" * 50)
  end

  def test_to_bool_true
    assert UtilClass.to_bool "true"
  end

  def test_to_bool_empty
    assert UtilClass.to_bool(nil) == false
  end

  def test_to_bool_default_true
    assert UtilClass.to_bool(nil, true)
  end

  def test_to_bool_true_bool
    assert UtilClass.to_bool true
  end

  def test_to_bool_false_bool
    assert UtilClass.to_bool(false) == false
  end
end
