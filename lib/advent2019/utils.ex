defmodule Advent2019.Utils do
  def priv_file(file) do
    :advent2019
    |> :code.priv_dir()
    |> Path.join(file)
    |> File.read!()
  end

  def priv_file_lines(file) do
    :advent2019
    |> :code.priv_dir()
    |> Path.join(file)
    |> File.stream!()
  end

  def priv_file_lines_as_integers(file) do
    file
    |> Advent2019.Utils.priv_file_lines()
    |> Stream.map(fn line ->
      line
      |> String.trim()
      |> String.to_integer()
    end)
  end
end
