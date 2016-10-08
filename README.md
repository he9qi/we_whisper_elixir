# Wechat Message Encryption Wrapper

[![Build Status][travis-img]][travis] [![Coverage Status][coverage-img]][coverage] [![Hex Version][hex-img]][hex] [![License][license-img]][license]

[coverage-img]: https://coveralls.io/repos/he9qi/we_whisper_elixir/badge.svg?branch=master&service=github
[coverage]: https://coveralls.io/github/he9qi/we_whisper_elixir?branch=master
[travis-img]: https://travis-ci.org/he9qi/we_whisper_elixir.svg?branch=master
[travis]: https://travis-ci.org/he9qi/we_whisper_elixir
[hex-img]: https://img.shields.io/hexpm/v/we_whisper.svg
[hex]: https://hex.pm/packages/we_whisper
[license-img]: http://img.shields.io/badge/license-MIT-brightgreen.svg
[license]: http://opensource.org/licenses/MIT

> An Elixir Wrapper for Wechat Message Encryption. [微信加密解密技术方案](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419318482&token=6e18ec982b3bc11a95683a6b6045cd3cf373f09d&lang=zh_CN)

## Installation

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
{:ok, decrypted_message} = whisper |> decrypt_message(encrypted_message)
```


#### Encrypt message

```elixir
encrypted_message = whisper |> encrypt_message(message, nonce, timestamp)
```
