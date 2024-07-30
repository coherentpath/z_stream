defmodule ZStream do
  @moduledoc """
  A module to compress and decompress data using various algorithms.
  """

  @type t :: module()

  @doc """
  A callback to compress an enumerable.
  """
  @callback compress(Enumerable.t(), keyword()) :: Enumerable.t()

  @doc """
  A callback to decompress an enumerable.
  """
  @callback decompress(Enumerable.t(), keyword()) :: Enumerable.t()

  defmodule CompressionError do
    @moduledoc """
    A general compression error.
    """

    defexception [:message]
  end

  ################################
  # Public API
  ################################

  @doc """
  Compress an enumerable using the provided implementation.
  """
  @spec compress(Enumerable.t(), t()) :: Enumerable.t()
  @spec compress(Enumerable.t(), t(), keyword()) :: Enumerable.t()
  def compress(stream, impl, opts \\ []) when is_atom(impl) do
    impl.compress(stream, opts)
  end

  @doc """
  Decompress an enumerable using the provided implementation.
  """
  @spec decompress(Enumerable.t(), t()) :: Enumerable.t()
  @spec decompress(Enumerable.t(), t(), keyword()) :: Enumerable.t()
  def decompress(stream, impl, opts \\ []) when is_atom(impl) do
    impl.decompress(stream, opts)
  end
end
