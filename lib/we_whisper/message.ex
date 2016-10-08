defmodule WeWhisper.Message do
  require Record
  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  @type t :: %__MODULE__{
    Encrypt: binary,
    MsgSignature: binary,
    TimeStamp: binary,
    Nonce: binary
  }

  defstruct [:Encrypt, :MsgSignature, :TimeStamp, :Nonce]

  @doc """
  Parse xml to message
  """
  @spec parse(binary) :: t
  def parse(message) do
    try do
      {:ok,
        %__MODULE__{
          Encrypt:      get_value_of_key(message, "Encrypt"),
          MsgSignature: get_value_of_key(message, "MsgSignature"),
          TimeStamp:    get_value_of_key(message, "TimeStamp"),
          Nonce:        get_value_of_key(message, "Nonce")
        }
      }
    rescue
      e in WeWhisper.Error -> {:error, e.reason}
    end
  end

  @doc """
  Convert message to xml.
  """
  @spec to_xml(binary, binary, binary, binary) :: binary
  def to_xml(encrypt, sign, timestamp, nonce) do
    to_xml(%__MODULE__{
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
  def to_xml(%__MODULE__{
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

  defp get_value_of_key(xml, key) when is_binary(xml) do
    try do
      { xml, _rest } = :xmerl_scan.string(:erlang.bitstring_to_list(xml))
      [ element ] = :xmerl_xpath.string(to_char_list("/xml/#{key}"), xml)
      [ text ] = xmlElement(element, :content)
      xmlText(text, :value) |> to_string
    catch
      :exit, _ -> raise WeWhisper.Error, reason: "failed to parse xml"
    end
  end
end
