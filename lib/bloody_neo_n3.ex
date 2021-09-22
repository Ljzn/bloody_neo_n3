defmodule BloodyNeoN3 do
  @moduledoc """
  Documentation for `BloodyNeoN3`.
  """
  alias BloodyNeoN3.{VariableLengthInteger, VariableLengthString}

  # @none 0
  # @called_by_entry 0x01
  @custom_contracts 0x10
  @custom_groups 0x20
  # @global 0x80

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

    {signers, binary} = decode_list(binary, &decode_signer/1)
    {attributes, binary} = decode_list(binary, &decode_attribute/1)

    {script, binary} = VariableLengthString.deserialize(binary)
    {witnesses, ""} = decode_list(binary, &decode_witness/1)

    %{
      version: version,
      nonce: nonce,
      sysfee: sysfee,
      netfee: netfee,
      valid_until_block: valid_until_block,
      signers: signers,
      attributes: attributes,
      script: script,
      witnesses: witnesses
    }
  end

  def decode_list(binary, fun) do
    {n, binary} = VariableLengthInteger.deserialize(binary)
    do_decode_list(binary, fun, n, [])
  end

  defp do_decode_list(binary, fun, 0, result), do: {Enum.reverse(result), binary}

  defp do_decode_list(binary, fun, n, result) do
    {data, binary} = fun.(binary)
    do_decode_list(binary, fun, n - 1, [data | result])
  end

  def encode_list(list, fun) do
    VariableLengthInteger.serialize(length(list)) <> Enum.map_join(list, fun)
  end

  def decode_signer(binary) do
    <<account::unsigned-little-size(160), scopes::8, binary::binary>> = binary

    if has_flag(scopes, @custom_contracts) do
      raise "not support custom contracts"
    end

    if has_flag(scopes, @custom_groups) do
      raise "not support custom groups"
    end

    {%{
       account: account,
       scopes: scopes
     }, binary}
  end

  def encode_signer(data) do
    <<data.account::unsigned-little-size(160), data.scopes::8>>
  end

  def has_flag(scopes, s) do
    Bitwise.band(scopes, s) != 0
  end

  def decode_attribute(_) do
    raise "not support attributes"
  end

  def encode_attribute(_) do
    raise "not support attributes"
  end

  def decode_witness(binary) do
    {invocation, binary} = VariableLengthString.deserialize(binary)
    {verification, binary} = VariableLengthString.deserialize(binary)
    {%{invocation: invocation, verification: verification}, binary}
  end

  def encode_witness(data) do
    VariableLengthString.serialize(data.invocation) <>
      VariableLengthString.serialize(data.verification)
  end

  def encode_tx(tx) do
    binary =
      <<tx.version::8, tx.nonce::unsigned-little-size(32), tx.sysfee::signed-little-size(64),
        tx.netfee::signed-little-size(64), tx.valid_until_block::unsigned-little-size(32)>>

    IO.iodata_to_binary([
      binary,
      encode_list(tx.signers, &encode_signer/1),
      encode_list(tx.attributes, &encode_attribute/1),
      VariableLengthString.serialize(tx.script),
      encode_list(tx.witnesses, &encode_witness/1)
    ])
  end

  def sign_tx() do
  end

  def txid() do
  end
end
