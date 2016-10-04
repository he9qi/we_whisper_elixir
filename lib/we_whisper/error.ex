defmodule WeWhisper.Error do
  defexception [:reason]
  def message(%__MODULE__{reason: :appid_not_match}), do: "App ID not match"
  def message(%__MODULE__{reason: :invalid_signature}), do: "Invalid signature"
  def message(%__MODULE__{reason: reason}) when is_binary(reason), do: reason
  def message(%__MODULE__{reason: reason}), do: inspect reason
end
