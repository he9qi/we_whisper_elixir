Wechat Message Encryption Wrapper
========

[微信加密解密技术方案](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419318482&token=6e18ec982b3bc11a95683a6b6045cd3cf373f09d&lang=zh_CN)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `we_whisper` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:we_whisper, "~> 0.1.0"}]
    end
    ```

  2. Ensure `we_whisper` is started before your application:

    ```elixir
    def application do
      [applications: [:we_whisper]]
    end
    ```

## Usage

#### Create whisper

```elixir
whisper = WeWhisper.Whisper.new appid, token, encoding_aes_key
```

#### Decrypt message

```elixir
whisper |> decrypt_message(encrypted_message, nonce, timestamp)
```


#### Encrypt message

```elixir
whisper |> encrypt_message(message, nonce, timestamp)
```
