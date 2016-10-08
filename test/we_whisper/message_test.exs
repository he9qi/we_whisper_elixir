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
    assert parse(@xml_message) == %Message{
      Encrypt: "xml_encrypted_message",
      MsgSignature: "signature",
      TimeStamp: "2016/10/10",
      Nonce: "nonce"
    }
  end
end
