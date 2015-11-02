require 'pry'
class Board

  WINNING_LINES = [ [1,2,3], 
                    [4,5,6], 
                    [7,8,9], 
                    [1,4,7], 
                    [2,5,8], 
                    [3,6,9], 
                    [1,5,9], 
                    [3,5,7]]

  attr_reader :board, :marker

  def initialize
    @board = {}
    (1..9).each { |position| @board[position] = " " }
    @marker = marker
  end

  def reset
    initialize
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
    board.select { |_, value| value == " "}.keys
  end

  def board_full?
    available_positions.size == 0
  end

  def mark_square(position, marker)
    @board[position] = marker
  end

  def computer_smart_move(board, marker)
    WINNING_LINES.each do |pattern|
      if @board.values_at(*pattern).count(marker) == 2 && @board.values_at(*pattern).count(" ") == 1
        pattern.each do |position|
          if @board[position] == " "
            return @board[position] = "O"
          end
        end
      end 
    end
    false
  end

  def count_markers(marker)
    WINNING_LINES.each do |pattern|
      return true if @board.values_at(*pattern).count(marker) == 3
    end
    nil
  end

end

class Human

  attr_accessor :name, :marker

end

class Computer

  attr_reader :name, :marker
  
  def initialize
    @name = "Mr.Computer"
    @marker = "O"
  end
  
end

class TicTacToe

  attr_reader :human, :board, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
    @board = Board.new
  end

  def check_winner
    return "Human" if board.count_markers(human.marker)
    return "Computer" if board.count_markers(computer.marker)
  end


  def get_name
    puts "Enter your name: "
    human.name = gets.chomp
  end

  def set_marker
    puts "Pick 1 character, any character except 'O': "
    human.marker = gets[0]
  end

  def computer_regular_move
    unless board.computer_smart_move(board, computer.marker) || board.computer_smart_move(board, human.marker)
      position = board.available_positions.sample
      board.mark_square(position, computer.marker)
    end
  end

  def human_move
    begin
      puts "Pick a position: #{board.available_positions}"
      position = gets.chomp.to_i
    end until board.available_positions.include?(position)
    board.mark_square(position, human.marker)

  end

  def play
    get_name
    set_marker
    loop do
      board.draw
      loop do
        human_move
        computer_regular_move unless check_winner
        board.draw
        break if check_winner || board.board_full?
      end

      if check_winner == "Human"
        puts "Congrats! #{human.name} wins this round."
      elsif check_winner == "Computer"
        puts "Sorry! #{computer.name} wins this round. "
      else
        puts "It's a draw."
      end
      board.reset

      puts "Play again? 'n' to quit "
      break if gets.chomp.downcase == 'n'

    end
  end
end

TicTacToe.new.play


