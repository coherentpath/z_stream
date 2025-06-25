defmodule ZStream.LZ4Test do
  use ExUnit.Case

  alias ZStream.LZ4

  test "compress" do
    data = StreamData.binary(length: 128_000)
    data = Enum.take(data, 10)
    stream = ZStream.compress(data, LZ4)

    assert :ok = Stream.run(stream)

    data = Enum.take(data, 0)
    stream = ZStream.compress(data, LZ4)

    assert :ok = Stream.run(stream)
  end

  test "decompress" do
    data = StreamData.binary(length: 128_000)
    data = Enum.take(data, 10)
    stream = ZStream.compress(data, LZ4)
    stream = ZStream.decompress(stream, LZ4)

    assert Enum.into(stream, "") == Enum.into(data, "")

    data = Enum.take(data, 0)
    stream = ZStream.compress(data, LZ4)
    stream = ZStream.decompress(stream, LZ4)

    assert Enum.into(stream, "") == ""
  end
end
