defmodule WeWhisper.MessageTest do
  use ExUnit.Case

  alias WeWhisper.Message
  import WeWhisper.Message

  @xml_message """
<xml>
<Encrypt><![CDATA[xml_encrypted_message]]></Encrypt>
<MsgSignature><![CDATA[signature]]></MsgSignature>
<TimeStamp>2016/10/10</TimeStamp>
<Nonce><![CDATA[nonce]]></Nonce>
</xml>
  """

  test "constructs XML message" do
    message  = %Message{
      Encrypt: "xml_encrypted_message",
      MsgSignature: "signature",
      TimeStamp: "2016/10/10",
      Nonce: "nonce"
    }

    assert to_xml(message) == @xml_message
  end

  test "parses message" do
    assert {:ok, "xml_encrypted_message"} == parse_encrypt_field(@xml_message)
  end

  test "parses invalid xml message" do
    assert {:error, %WeWhisper.Error{reason: "failed to parse xml"}} ==
      parse_encrypt_field("invalid_xml")
  end
end
