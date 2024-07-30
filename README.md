# ZStream

Compress and decompress data using various algorithms.

## Installation

Add `z_stream` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:z_stream, git: "https://github.com/coherentpath/z_stream", tag: "v*.*.*"}
  ]
end
```

## Usage

Compression algorithms are implemented as modules that adhere to the `ZStream`
behaviour. Simply pass in the module to the main `ZStream.compress/2` and 
`ZStream.decompress/2` functions.

```elixir
alias ZStream.LZ4

data = ["foo", "bar", "baz"]
data = ZStream.compress(data, LZ4)
data = ZStream.decompress(data, LZ4)
Enum.into(data, "")
```

As of now, the following compression algorithms are available:

- [LZ4](https://lz4.org/) via `ZStream.LZ4`
- [ZStandard](https://facebook.github.io/zstd/) via `ZStream.Zstandard`
