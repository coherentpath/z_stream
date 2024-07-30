defmodule ZStreamTest do
  use ExUnit.Case
  doctest ZStream

  test "greets the world" do
    assert ZStream.hello() == :world
  end
end
