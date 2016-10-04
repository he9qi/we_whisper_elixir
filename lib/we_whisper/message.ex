defmodule WeWhisper.Message do
  require Record
  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  @type t :: %{
    Encrypt: binary,
    MsgSignature: binary,
    TimeStamp: binary,
    Nonce: binary
  }

  @doc """
  Convert message to xml.
  """
  @spec to_xml(binary, binary, binary, binary) :: binary
  def to_xml(encrypt, sign, timestamp, nonce) do
    to_xml(%{
      Encrypt: encrypt,
      MsgSignature: sign,
      TimeStamp: timestamp,
      Nonce: nonce
    })
  end

  @doc """
  Convert message hash to xml.
  """
  @spec to_xml(t) :: binary
  def to_xml(%{
    Encrypt: content,
    MsgSignature: signature,
    TimeStamp: timestamp,
    Nonce: nonce
  }) do """
<xml>
<Encrypt><![CDATA[#{content}]]></Encrypt>
<MsgSignature><![CDATA[#{signature}]]></MsgSignature>
<TimeStamp>#{timestamp}</TimeStamp>
<Nonce><![CDATA[#{nonce}]]></Nonce>
</xml>
"""
  end

  @doc """
  Get encrypted content from message
  """
  @spec get_encrypted_content(t) :: binary
  def get_encrypted_content(message) do
    get_value_of_key(message, "Encrypt")
  end

  @doc """
  Get signature content from message
  """
  @spec get_signature(t|binary) :: binary
  def get_signature(message) do
    get_value_of_key(message, "MsgSignature")
  end

  defp get_value_of_key(%{MsgSignature: signature}, "MsgSignature"), do: signature
  defp get_value_of_key(%{Encrypt: content}, "Encrypt"), do: content
  defp get_value_of_key(xml, key) when is_binary(xml) do
    { xml, _rest } = :xmerl_scan.string(:erlang.bitstring_to_list(xml))
    [ element ] = :xmerl_xpath.string(to_char_list("/xml/#{key}"), xml)
    [ text ] = xmlElement(element, :content)
    xmlText(text, :value) |> to_string
  end

end
