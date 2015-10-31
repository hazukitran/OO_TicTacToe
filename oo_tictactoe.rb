# Draw a board
# Human = 'X'
# Computer = "O"
# check empty_position?
# check board_full?
# render board
# check_winner

require 'pry'

class Board

  WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]

  attr_accessor :board

  def initialize
    @board = {}
    (1..9).each { |position| @board[position] = " " }
  end

  def available_positions
    board.select { |key, value| value == " "}.keys
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

  def board_full?
    available_positions.size == 0
  end

  def check_winner
    WINNING_LINES.each do |pattern|
      return "Player" if board.values_at(*pattern).count("X") == 3
      return "Computer" if board.values_at(*pattern).count("O") == 3
    end
    nil
  end

end

class Player

  attr_accessor :board, :position

  def initialize
    @position = position 
    @board = Board.new
  end

end

class Human < Player

  attr_accessor :name

  def get_name
    puts "Enter your name: "
    gets.chomp
  end

  def human_marker
    puts "Pick any character except 'O': "
    gets.chomp
  end

  def place_move
    begin
      puts "Pick a position: #{board.available_positions}"
      self.position = gets.chomp.to_i
    end until board.available_positions.include?(self.position)
      board[position] = human_marker
  end

end

class Computer < Player

  attr_accessor :human, :name

  def initialize(marker)
    @human = Human.new
    @name = "Mr.Computer"
  end 

  def winning_moves
    Board::WINNING_LINES.each do |pattern|
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

  def place_move
    unless winning_moves(board, "O") || winning_moves(board, human.human_marker)
      position = available_positions(board).sample
      board[position] = "O"
    end
  end

end

# game engine
class Game

  attr_accessor :human, :computer, :board

  def initialize
    @human = Human.new
    @computer = Computer("O")
    @board = Board.new
    @current_player = @human
  end

  def alternate_player
    if @current_player == human
      @current_player = computer
    else
      @current_player = human
    end
  end

  def play_again?
    puts "Play again? 'n' to quit"
    gets.chomp.downcase == 'n'

  def play
    begin
      loop do
        board.draw
        @current_player.place_move

        if @current_player.(board.check_winner)
          puts "#{current_player.name} wins."
          break
        elsif board.board_full?
          puts "It's a draw."
          break
        else
          alternate_player
        end
      end
    
      board.draw
      break if play_again?
      initialize  
    end
  end

end

Game.new.play