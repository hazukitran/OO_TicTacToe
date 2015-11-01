require 'pry'
class Board

  attr_accessor :board, :marker

  def initialize
    @board = {}
    (1..9).each { |position| @board[position] = " " }
    @value = marker
  end

  def draw
    system 'clear'
    puts "     |     |   "
    puts "  #{@board[1]}  |  #{@board[2]}  |  #{@board[3]}  "
    puts "     |     |   "
    puts "----------------"
    puts "     |     |   "
    puts "  #{@board[4]}  |  #{@board[5]}  |  #{@board[6]}  "
    puts "     |     |   "
    puts "----------------"
    puts "     |     |   "
    puts "  #{@board[7]}  |  #{@board[8]}  |  #{@board[9]}  "
    puts "     |     |   "
  end 
   
  def available_positions
    board.select { |key, value| value == " "}.keys
  end

  def board_full?
    available_positions.size == 0
  end

end

class Human

  attr_accessor :name, :marker

  def initialize
    @name = name
    @marker = marker
  end

  def name
    puts "Enter your name: "
    gets.chomp
  end

  def marker
    puts "Pick any character except 'O': "
    gets.chomp
  end

end

class Computer

  attr_accessor :name, :position, :marker
  
  def initialize
    @name = "Mr.Robot"
    @position = position
    @marker = "O"
  end
  
end

class TicTacToe

  WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]

  attr_accessor :human, :board, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
    @board = Board.new
    @current_player = @human
  end

  def check_winner
    WINNING_LINES.each do |pattern|
      return "#{human.name}" if board.values_at(*pattern).count("X") == 3
      return "#{computer.name}" if board.values_at(*pattern).count("O") == 3
    end
    nil
  end

  def winning_moves
    TicTacToe::WINNING_LINES.each do |pattern|
      if board.values_at(*pattern).count(symbol) == 2 && board.values_at(*pattern).count(" ") == 1
        pattern.each do |position|
          if board[position] == " "
            return board[position] = "O"
          end
        end
      end 
    end
    false
  end

  def computer_move
    unless winning_moves(board, computer.marker) || winning_moves(board, human.marker)
      position = board.available_positions.sample
      board[position] = computer.marker
    end
  end

  def human_move
    begin
      puts "Pick a position: #{board.available_positions}"
      position = gets.chomp.to_i
    end until board.available_positions.include?(position)
    board[position] = human.marker
  end

  def alternate_player
    if @current_player == @human
      human_move
    else
      computer_move
    end
  end

  def play_again?
    puts "Play again? 'n' to quit "
    gets.chomp.downcase == 'n'
  end

  def play
    board.draw
    loop do
      alternate_player
      board.draw

      if check_winner
        puts "The winner is #{@current_player.name}!"
        break
      elsif board.board_full?
        puts "It's a draw."
        break
      else
        alternate_player
      end

      break if play_again?

    end
  end
end

TicTacToe.new.play


