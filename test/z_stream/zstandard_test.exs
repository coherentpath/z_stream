defmodule ZStream.ZstandardTest do
  use ExUnit.Case

  alias ZStream.Zstandard

  test "compress" do
    data = StreamData.binary(length: 128_000)
    data = Enum.take(data, 10)
    stream = ZStream.compress(data, Zstandard)

    assert :ok = Stream.run(stream)

    data = Enum.take(data, 0)
    stream = ZStream.compress(data, Zstandard)

    assert :ok = Stream.run(stream)
  end

  test "decompress" do
    data = StreamData.binary(length: 128_000)
    data = Enum.take(data, 10)
    stream = ZStream.compress(data, Zstandard)
    stream = ZStream.decompress(stream, Zstandard)

    assert Enum.into(stream, "") == Enum.into(data, "")

    data = Enum.take(data, 0)
    stream = ZStream.compress(data, Zstandard)
    stream = ZStream.decompress(stream, Zstandard)

    assert Enum.into(stream, "") == ""
  end
end
