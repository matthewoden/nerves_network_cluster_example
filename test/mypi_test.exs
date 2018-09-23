defmodule MypiTest do
  use ExUnit.Case
  doctest Mypi

  test "greets the world" do
    assert Mypi.hello() == :world
  end
end
