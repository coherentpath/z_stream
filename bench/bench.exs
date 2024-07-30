alias ZStream.LZ4
alias ZStream.Zstandard

raw_large_binary = StreamData.binary(length: 128_000)
raw_large_binary = Enum.take(raw_large_binary, 100)

raw_medium_binary = StreamData.binary(length: 32_000)
raw_medium_binary = Enum.take(raw_medium_binary, 100)

raw_small_binary = StreamData.binary(length: 8000)
raw_small_binary = Enum.take(raw_small_binary, 100)

Benchee.run(
  %{
    "LZ4.compress large" => fn -> raw_large_binary |> ZStream.compress(LZ4) |> Stream.run() end,
    "Zstandard.compress large" => fn ->
      raw_large_binary |> ZStream.compress(Zstandard) |> Stream.run()
    end
  },
  warmup: 4,
  memory_time: 5
)

Benchee.run(
  %{
    "LZ4.compress medium" => fn -> raw_medium_binary |> ZStream.compress(LZ4) |> Stream.run() end,
    "Zstandard.compress medium" => fn ->
      raw_medium_binary |> ZStream.compress(Zstandard) |> Stream.run()
    end
  },
  warmup: 4,
  memory_time: 5
)

Benchee.run(
  %{
    "LZ4.compress small" => fn -> raw_small_binary |> ZStream.LZ4.compress([]) |> Stream.run() end,
    "Zstandard.compress small" => fn ->
      raw_small_binary |> ZStream.compress(Zstandard) |> Stream.run()
    end
  },
  warmup: 4,
  memory_time: 5
)

lz4_large_binary = ZStream.compress(raw_large_binary, LZ4)
zstandard_large_binary = ZStream.compress(raw_large_binary, Zstandard)

lz4_medium_binary = ZStream.compress(raw_medium_binary, LZ4)
zstandard_medium_binary = ZStream.compress(raw_medium_binary, Zstandard)

lz4_small_binary = ZStream.compress(raw_small_binary, LZ4)
zstandard_small_binary = ZStream.compress(raw_small_binary, Zstandard)

Benchee.run(
  %{
    "LZ4.decompress large" => fn ->
      lz4_large_binary |> ZStream.decompress(LZ4) |> Stream.run()
    end,
    "Zstandard.decompress large" => fn ->
      zstandard_large_binary |> ZStream.decompress(Zstandard) |> Stream.run()
    end
  },
  warmup: 4,
  memory_time: 5
)

Benchee.run(
  %{
    "LZ4.decompress medium" => fn ->
      lz4_medium_binary |> ZStream.decompress(LZ4) |> Stream.run()
    end,
    "Zstandard.decompress medium" => fn ->
      zstandard_medium_binary |> ZStream.decompress(Zstandard) |> Stream.run()
    end
  },
  warmup: 4,
  memory_time: 5
)

Benchee.run(
  %{
    "LZ4.decompress small" => fn ->
      lz4_small_binary |> ZStream.decompress(LZ4) |> Stream.run()
    end,
    "Zstandard.decompress small" => fn ->
      zstandard_small_binary |> ZStream.decompress(Zstandard) |> Stream.run()
    end
  },
  warmup: 4,
  memory_time: 5
)
