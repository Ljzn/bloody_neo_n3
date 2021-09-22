defmodule BloodyNeoN3.VariableLengthString do
  alias BloodyNeoN3.VariableLengthInteger

  @doc """
  Serialzie variable length string. Serialization rules can be found at [Bitcoin protocol document](https://en.bitcoin.it/wiki/Protocol_documentation#Variable_length_string)
  """
  def serialize(str) do
    (byte_size(str) |> VariableLengthInteger.serialize()) <> str
  end

  def deserialize(data) do
    {string_size, data} = VariableLengthInteger.deserialize(data)
    <<string::bytes-size(string_size), data::binary>> = data
    {string, data}
  end
end
