defmodule WeWhisper.CryptorTest do
  use ExUnit.Case

  import WeWhisper.Cryptor
  import Mock

  def timestamp, do: "1415979516"
  def nonce, do: "1320562132"
  def signature, do: "096d8cda45e4678ca23460f6b8cd281b3faf1fc3"
  def appid, do: "wx2c2769f8efd9abc2"
  def encoding_aes_key, do: "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFG"
  def encrypted, do: "3kKZ++U5ocvIF8dAHPct7xvUqEv6vplhuzA8Vwj7OnVcBu9fdmbbI41zclSfKqP6/bdYAxuE3x8jse43ImHaV07siJF473TsXhl8Yt8task0n9KC7BDA73mFTwlhYvuCIFnU6wFlzOkHyM5Bh2qpOHYk5nSMRyUG4BwmXpxq8TvLgJV1jj2DXdGW4qdknGLfJgDH5sCPJeBzNC8j8KtrJFxmG7qIwKHn3H5sqBf6UqhXFdbLuTWL3jwE7yMLhzOmiHi/MX/ZsVQ7sMuBiV6bW0wkgielESC3yNUPo4q/RMAFEH0fRLr76BR5Ct0nUbf9PdClc0RdlYcztyOs54X/KLbYRNCQ2kXxmJYL6ekdNe70PCAReIEfXEp+pGpry4ss8bD6LKAtNvBJUwHshZe6sbf+fOiDiuKEqp1wdQLmgN+8nX62LklySWr8QrNCpsmKClxco0kbVYNX/QVh5yd0UA1sAqIn6baZ9G+Z/OXG+Q4n9lUuzLprLhDBPaCvXm4N14oqXNcw7tqU2xfhYNIDaD72djyIc/4eyAi2ZsJ+3hb+jgiISR5WVveRWYYqGZGTW3u+27JiXEo0fs3DQDbGVIcYxaMgU/RRIDdXzZSFcf6Z1azjzCDyV9FFEsicghHn"
  def message, do: "<xml><ToUserName><![CDATA[oia2TjjewbmiOUlr6X-1crbLOvLw]]></ToUserName><FromUserName><![CDATA[gh_7f083739789a]]></FromUserName><CreateTime>1407743423</CreateTime><MsgType>  <![CDATA[video]]></MsgType><Video><MediaId><![CDATA[eYJ1MbwPRJtOvIEabaxHs7TX2D-HV71s79GUxqdUkjm6Gs2Ed1KF3ulAOA9H1xG0]]></MediaId><Title><![CDATA[testCallBackReplyVideo]]></Title><Description><![CDATA[testCallBackReplyVideo]]></Description></Video></xml>"

  test "decripts message" do
    {decrypted_appid, decrypted_message}  = decrypt(encrypted, encoding_aes_key)

    assert decrypted_message == message
    assert decrypted_appid == appid
  end

  test "encripts message" do
    with_mock SecureRandom, [base64: fn(_size) -> "HLFOQjbkfgUh46s8" end] do
      encrypted_message = encrypt(message, appid, encoding_aes_key)
      assert encrypted_message == encrypted
    end
  end

  test "double" do
    encrypted = encrypt(message, appid, encoding_aes_key)
    {decrypted_appid, decrypted_message}  = decrypt(encrypted, encoding_aes_key)

    assert decrypted_message == message
    assert decrypted_appid == appid
  end
end
