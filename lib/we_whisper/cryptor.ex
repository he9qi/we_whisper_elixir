defmodule WeWhisper.Cryptor do

  @block_pad_size 32

  @doc """
  Decrypt encrypted message using encoded AES key
  Returns appid and decrypted message
  """
  @spec decrypt(binary, binary) :: {binary, binary}
  def decrypt(msg_encrypt, encoding_aes_key) do
    plain_text =
      msg_encrypt
      |> Base.decode64!
      |> decrypt_aes(encoding_aes_key)
      |> decode_padding

    <<_ :: binary-size(16),
      msg_len :: integer-size(32),
      msg :: binary-size(msg_len),
      appid :: binary>> = plain_text

    {appid, msg}
  end

  @doc """
  Encrypt message using encoded AES key and appid
  Returns encrypted message
  """
  @spec encrypt(binary, binary, binary) :: binary
  def encrypt(message, appid, encoding_aes_key) do
    message
      |> pack_with_appid(appid)
      |> encode_padding
      |> encrypt_aes(encoding_aes_key)
      |> Base.encode64
  end

  defp decrypt_aes(aes_encrypt, encoding_aes_key) do
    aes_key = encoding_aes_key <> "=" |> Base.decode64!
    iv = binary_part(aes_key, 0, 16)
    :crypto.block_decrypt(:aes_cbc128, aes_key, iv, aes_encrypt)
  end

  defp decode_padding(padded_text) do
    len = byte_size(padded_text)
    <<pad :: utf8>> = binary_part(padded_text, len, -1)
    case pad < 1 or pad > @block_pad_size do
      true -> binary_part(padded_text, 0, len)
      false -> binary_part(padded_text, 0, len-pad)
    end
  end

  defp encrypt_aes(aes_decrypt, encoding_aes_key) do
    aes_key = encoding_aes_key <> "=" |> Base.decode64!
    iv = binary_part(aes_key, 0, 16)

    :crypto.block_encrypt(:aes_cbc128, aes_key, iv, aes_decrypt)
  end

  defp encode_padding(data) do
    length = byte_size(data)
    size_rem = @block_pad_size - rem(length, @block_pad_size)
    amount_to_pad = case size_rem == 0 do
      true -> @block_pad_size
      false -> size_rem
    end
    pad_size = <<amount_to_pad :: size(8)>>
    padding = 1..amount_to_pad |> Enum.map(fn(_) -> pad_size end) |> Enum.join
    data <> padding
  end

  defp pack_with_appid(message, appid) do
    random = SecureRandom.base64(12)
    msg_len = <<String.length(message) :: size(32)>>
    random <> msg_len <> message <> appid
  end

end
