defmodule WeWhisper.MessageTest do
  use ExUnit.Case

  import WeWhisper.Message

  test "constructs XML message" do
    message  = %{
      Encrypt: "hello",
      MsgSignature: "signature",
      TimeStamp: "2016/10/10",
      Nonce: "nonce"
    }

    expected_xml_message = """
<xml>
<Encrypt><![CDATA[hello]]></Encrypt>
<MsgSignature><![CDATA[signature]]></MsgSignature>
<TimeStamp>2016/10/10</TimeStamp>
<Nonce><![CDATA[nonce]]></Nonce>
</xml>
"""
    assert to_xml(message) == expected_xml_message
  end

  def xml_message do
    """
<xml>
<Encrypt>xml_encrypted_message</Encrypt>
</xml>
"""
  end

  describe "extracts value from hash message" do
    test "parses encrypted content from Hash message" do
      assert get_encrypted_content(%{Encrypt: "hash_encrypted", Nonce: "nonce"}) == \
        "hash_encrypted"
    end

    test "parse signature from Hash message" do
      assert get_signature(%{MsgSignature: "signature"}) == \
        "signature"
    end
  end

  test "parses encrypted content from XML message" do
    assert get_encrypted_content(xml_message) == \
      "xml_encrypted_message"
  end
end
