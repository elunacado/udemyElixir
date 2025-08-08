#This is a module for managing a deck of cards.
#, a module is a collection of functions and data structures.
defmodule Cards do
  def salute do
    IO.puts("Hi sir/ma'am welcome to the table")
    IO.puts("With how many decks would you like to play with?")
  end

  def convertTextToNumber(text) do
    case Integer.parse(text) do
      {number, ""} -> number
    _ -> :error
    end
  end

  def shuffle(shoe) do
    shuffleShoe = Enum.shuffle(Enum.shuffle(shoe))
    shuffleShoe
  end

  def createShoe( decks,suits, ranks) do
    shoe =
      Enum.flat_map(1..decks, fn _deck ->
        Enum.flat_map(suits, fn suit ->
          Enum.map(ranks, fn rank ->
            "#{rank}#{suit}"
          end)
      end)
    end)
    shuffledShoe = shuffle(shoe)
    shuffledShoe
  end

  def containsRank?(shoe, request) do
    Enum.any?(shoe, fn card ->
      String.starts_with?(card, request)
    end)
  end

  @spec burnCards(list()) :: list() | {:error, <<_::280>>}
  def burnCards(shoe) do
    case List.pop_at(shoe, 0) do
      {nil, []} -> {:error, "There are no more cards in the deck"}
      {card, rest} -> IO.puts("Burnt card: #{card}")
      rest
    end
  end

  def game do
    suits = ["♥", "♦", "♣", "♠"]
    ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
    salute()
    numberOfDecks = convertTextToNumber(IO.gets("> ") |> String.trim())

    case burnCards(createShoe(numberOfDecks, suits, ranks)) do
      {:error, message} ->
        IO.puts("Error: #{message}")

    end
  end
end
