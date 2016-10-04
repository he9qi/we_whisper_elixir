defmodule WeWhisper.ErrorTest do
  use ExUnit.Case

  test "it raises invalid signature error message" do
    assert_raise WeWhisper.Error, "Invalid signature", fn ->
      raise WeWhisper.Error, reason: :invalid_signature
    end
  end

  test "it raises app ID not match error message" do
    assert_raise WeWhisper.Error, "App ID not match", fn ->
      raise WeWhisper.Error, reason: :appid_not_match
    end
  end


  test "it raises string error message" do
    assert_raise WeWhisper.Error, "Wechat Error", fn ->
      raise WeWhisper.Error, reason: "Wechat Error"
    end
  end

  test "it raises non-string error message" do
    error = %{:error => "Wechat Error"}
    reason_message = inspect error

    assert_raise WeWhisper.Error, reason_message, fn ->
      raise WeWhisper.Error, reason: error
    end
  end
end
