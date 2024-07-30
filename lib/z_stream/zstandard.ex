defmodule ZStream.Zstandard do
  @moduledoc """
  An implementation of `ZStream` using [ZStandard](https://facebook.github.io/zstd/).
  """

  @behaviour ZStream

  alias ZStream.CompressionError

  @default_buffer 32_768

  ################################
  # ZStream Callbacks
  ################################

  @impl ZStream
  def compress(stream, opts) do
    Stream.transform(
      stream,
      fn -> do_compress_start(opts) end,
      &do_compress/2,
      &do_compress_end/1
    )
  end

  @impl ZStream
  def decompress(stream, opts) do
    Stream.transform(
      stream,
      fn -> do_decompress_start(opts) end,
      &do_decompress/2,
      &do_decompress_end/1
    )
  end

  ################################
  # Private API
  ################################

  defp do_compress_start(opts) do
    buffer = Keyword.get(opts, :buffer, @default_buffer)

    case :ezstd.create_compression_context(buffer) do
      {:error, reason} -> raise CompressionError, "failed to start compress: #{inspect(reason)}"
      ref -> ref
    end
  end

  defp do_compress(elem, ref) do
    case :ezstd.compress_streaming(ref, elem) do
      {:error, reason} -> raise CompressionError, "failed to compress: #{inspect(reason)}"
      elem -> {:erlang.iolist_to_iovec(elem), ref}
    end
  end

  defp do_compress_end(ref) do
    case :ezstd.compress_streaming_end(ref, <<>>) do
      {:error, reason} -> raise CompressionError, "failed to end compress: #{inspect(reason)}"
      elem -> {:erlang.iolist_to_iovec(elem), :ok}
    end
  end

  defp do_decompress_start(opts) do
    buffer = Keyword.get(opts, :buffer, @default_buffer)

    case :ezstd.create_decompression_context(buffer) do
      {:error, reason} -> raise CompressionError, "failed to start decompress: #{inspect(reason)}"
      ref -> ref
    end
  end

  defp do_decompress(elem, ref) do
    case :ezstd.decompress_streaming(ref, elem) do
      {:error, reason} -> raise CompressionError, "failed to decompress: #{inspect(reason)}"
      elem -> {:erlang.iolist_to_iovec(elem), ref}
    end
  end

  defp do_decompress_end(ref) do
    case :ezstd.decompress_streaming(ref, <<>>) do
      {:error, reason} -> raise CompressionError, "failed to end decompress: #{inspect(reason)}"
      elem -> {:erlang.iolist_to_iovec(elem), :ok}
    end
  end
end
