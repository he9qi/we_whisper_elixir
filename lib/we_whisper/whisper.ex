defmodule WeWhisper.Whisper do
  @moduledoc """
    This module defines the `WeWhisper.Whisper` struct
  """

  alias WeWhisper.Cryptor
  alias WeWhisper.Message
  alias WeWhisper.Error
  alias WeWhisper.Signature

  @type appid            :: binary
  @type token            :: binary
  @type encoding_aes_key :: binary

  @type t :: %__MODULE__{
              appid:            appid,
              token:            token,
              encoding_aes_key: encoding_aes_key}

  defstruct appid: "",
            token: "",
            encoding_aes_key: ""

  @doc """
  Returns a new `WeWhisper.Whisper` struct given appid `string`, token `string`
  and encoding_aes_key `string`.
  """
  @spec new(binary, binary, binary) :: t
  def new(appid, token, encoding_aes_key) do
    struct __MODULE__, [
      appid:            appid,
      token:            token,
      encoding_aes_key: encoding_aes_key]
  end

  @doc """
  Decrypts message
  """
  @spec decrypt_message(t, appid, token, encoding_aes_key) :: {:ok, binary} | {:error, Error}
  def decrypt_message(%WeWhisper.Whisper{appid: appid, token: token, encoding_aes_key: encoding_aes_key}, message, nonce \\ "", timestamp \\ "") do
    encrypted_text = Message.get_encrypted_content(message)
    signature = Message.get_signature(message)
    sign = Signature.sign(token, timestamp, nonce, encrypted_text)

    case sign != signature do
      true -> {:error, %Error{reason: :invalid_signature}}
      false ->
        {decrypted_appid, decrypted_message} = Cryptor.decrypt(encrypted_text, encoding_aes_key)
        case appid != decrypted_appid do
          true -> {:error, %Error{reason: :appid_not_match}}
          false -> {:ok, decrypted_message}
        end
    end
  end

  @doc """
  Encrypt message
  """
  @spec encrypt_message(t, binary, binary, binary) :: binary
  def encrypt_message(%WeWhisper.Whisper{appid: appid, token: token, encoding_aes_key: encoding_aes_key}, message, nonce, timestamp) do
    encrypt = Cryptor.encrypt(message, appid, encoding_aes_key)
    sign = Signature.sign(token, timestamp, nonce, encrypt)
    Message.to_xml(encrypt, sign, timestamp, nonce)
  end

end
