defmodule Protox.VarintTest do
  use ExUnit.Case
  use PropCheck

  test "Encode" do
    assert Protox.Encode.encode_varint(300) == [<<172>>, <<2>>]
    assert Protox.Encode.encode_varint(0) == <<0>>
    assert Protox.Encode.encode_varint(1) == <<1>>
  end

  test "Decode" do
    assert Protox.Decode.decode_varint(<<172, 2>>) == {300, <<>>}
    assert Protox.Decode.decode_varint(<<172, 2, 0>>) == {300, <<0>>}
    assert Protox.Decode.decode_varint(<<0>>) == {0, <<>>}
    assert Protox.Decode.decode_varint(<<1>>) == {1, <<>>}
    assert Protox.Decode.decode_varint(<<185, 96>>) == {12_345, <<>>}
    assert Protox.Decode.decode_varint(<<185, 224, 0>>) == {12_345, <<>>}
  end

  test "Symmetric" do
    forall value <- integer() do
      encoded = value |> Protox.Encode.encode_varint() |> :binary.list_to_bin()
      {decoded, <<>>} = Protox.Decode.decode_varint(encoded)

      value == decoded
    end
  end
end
