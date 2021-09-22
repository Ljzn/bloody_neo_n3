defmodule BloodyNeoN3 do
  @moduledoc """
  Documentation for `BloodyNeoN3`.
  """

  def decode_block() do
  end

  def encode_block() do
  end

  """
  00  1AAE803C
  CB1F4C0000000000
  6FEC120000000000
  FEEC0400
  01986F9A43CA46C1691B1DB1D4F348A1212334CCF001005610110C140DA967A400432BF27F8E8EB46FE8AC659ECCDE040C14986F9A43CA46C1691B1DB1D4F348A1212334CCF014C01F0C087472616E736665720C14F563EA40BC283D4D0E05C48EA305B3F2A07340EF41627D5B5201420C409778898DBF3F6365EF1BF02902A888F8AC5E5299005D590F78D8D991090DF7B5E5F024688058403AEAE1C8457E29F3F20E5F579EF5624F1E6D8F8C3B62CA5BFB280C2102AC5AD375BAA5FADA222E06892543BADF0C08103017902C468E4CBCB5414CCA7E4156E7B32
  """

  def decode_tx(binary) when is_binary(binary) do
    <<version::8, nonce::unsigned-little-size(32), sysfee::signed-little-size(64),
      netfee::signed-little-size(64), valid_until_block::unsigned-little-size(32),
      binary::binary>> = binary

    %{
      version: version,
      nonce: nonce,
      sysfee: sysfee,
      netfee: netfee,
      valid_until_block: valid_until_block
      # signers:,
      # attributes:,
      # script:,
      # witnesses:,
    }
  end

  def encode_tx() do
  end

  def sign_tx() do
  end

  def txid() do
  end
end
