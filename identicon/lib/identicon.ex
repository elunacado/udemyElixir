defmodule Identicon do
#Pipe functions allow us to pass the result of one function as the first argument to the next function
  def main(input) do
    case input do
      s when is_binary(s) ->
        s
        |> hash_input()
        |> select_color()
        |> build_grid()
        |> filter_odd_squares()
        # Error handler
        _ ->
          {:error, "El input debe ser un string"}
      end
  end

###  Hashes the input string
# Call the struct, and assign it the hashed value
  def hash_input(input) do
      seed = :crypto.hash(:md5, input)
      |> :binary.bin_to_list

      %Identicon.Image{seed: seed}
    end

### Selects the color from the seed
# We use the first three values of the seed to pick a color
# And updates the image struct with the selected color
  def select_color(image = %Identicon.Image{seed: [red, green, blue | _tail]}) do
      %Identicon.Image{image | color: {red, green, blue}}
  end

### Builds the grid for the identicon
# We take the seed and create a grid of 25 elements
  def build_grid(image = %Identicon.Image{seed: seed}) do
    grid =
      seed
      |> Enum.drop(-1)
      |> Enum.chunk_every(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end

  def filter_odd_squares(image = %Identicon.Image{grid: grid}) do
    grid = Enum.filter grid, fn({value, _index}) ->
      rem(value, 2) == 0
    end
    %Identicon.Image{image | grid: grid}
  end

end

"""
 To compile the program
 iex -S mix
"""
