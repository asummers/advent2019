defmodule Advent2019.Utils do
  def priv_file_lines(file) do
    :advent2019
    |> :code.priv_dir()
    |> Path.join(file)
    |> File.stream!()
  end
end
