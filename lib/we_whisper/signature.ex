defmodule WeWhisper.Signature do

  @type t :: %{
    token: binary,
    timestamp: binary,
    nonce: binary,
    encrypted: binary
  }

  @doc """
  Create signature for encrypted message
  """
  @spec sign(t) :: binary
  def sign(%{token: token, timestamp: timestamp, nonce: nonce, encrypted: encrypted}) do
    [token, timestamp, nonce, encrypted]
      |> Enum.reject(&(&1 == nil))
      |> Enum.map(&("#{&1}"))
      |> Enum.sort
      |> Enum.join
      |> encrypt
  end

  @doc """
  Create signature for encrypted message
  """
  @spec sign(binary, binary, binary, binary) :: binary
  def sign(token, timestamp, nonce, encrypted) do
    [token, timestamp, nonce, encrypted]
      |> Enum.reject(&(&1 == nil))
      |> Enum.map(&("#{&1}"))
      |> Enum.sort
      |> Enum.join
      |> encrypt
  end

  defp encrypt(string) do
    :crypto.hash(:sha, string)
      |> Base.encode16(case: :lower)
  end

end
