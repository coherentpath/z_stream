defmodule ZStream.LZ4 do
  @moduledoc """
  An implementation of `ZStream` using [LZ4](https://lz4.org/).
  """

  @behaviour ZStream

  ################################
  # ZStream Callbacks
  ################################

  @impl ZStream
  def compress(stream, _opts) do
    Stream.transform(
      stream,
      fn -> do_compress_start() end,
      &do_compress/2,
      &do_compress_end/1,
      &do_compress_exit/1
    )
  end

  @impl ZStream
  def decompress(stream, _opts) do
    Stream.transform(
      stream,
      fn -> do_decompress_start() end,
      &do_decompress/2,
      &do_decompress_exit/1
    )
  end

  ################################
  # Private API
  ################################

  defp do_compress_start do
    ref = :lz4f.create_compression_context()
    {:start, ref}
  end

  defp do_compress(elem, {:start, ref}) do
    begin = :lz4f.compress_begin(ref)
    elem = :lz4f.compress_update(ref, elem)
    {:erlang.iolist_to_iovec([begin, elem]), ref}
  end

  defp do_compress(elem, ref) do
    elem = :lz4f.compress_update(ref, elem)
    {:erlang.iolist_to_iovec(elem), ref}
  end

  defp do_compress_end({:start, ref}) do
    finish = :lz4f.compress_end(ref)
    {:erlang.iolist_to_iovec(finish), ref}
  end

  defp do_compress_end(ref) do
    finish = :lz4f.compress_end(ref)
    {:erlang.iolist_to_iovec(finish), ref}
  end

  defp do_compress_exit(ref) do
    :lz4f.compress_end(ref)
  end

  defp do_decompress_start do
    :lz4f.create_decompression_context()
  end

  defp do_decompress(elem, ref) do
    elem = :lz4f.decompress(ref, elem)
    {:erlang.iolist_to_iovec(elem), ref}
  end

  defp do_decompress_exit(_ref), do: :ok
end
