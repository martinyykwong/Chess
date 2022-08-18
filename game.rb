require_relative 'board'
require_relative 'display'
require_relative 'players/humanplayer'
require_relative 'players/computerplayer'

class Game

    attr_reader :board, :display, :player1, :player2
    attr_accessor :current_player

    def initialize(human1 = true, human2 = true)
        @board = Board.new
        @display = Display.new(@board)
        if human1 == true
            @player1 = HumanPlayer.new("white", @display)
        else
            @player1 = ComputerPlayer.new("white", @display)
        end

        if human2 == true
            @player2 = HumanPlayer.new("black", @display)
        else
            @player2 = ComputerPlayer.new("black", @display)
        end
        @current_player = @player1

    end

    def play

        begin
        until (current_player.color == "white" && board.checkmate?("white")) || (current_player.color == "black" && board.checkmate?("black"))
            while true
                system("clear")
                self.display.render
                puts "#{self.current_player.color.capitalize}'s turn to move. Choose a piece"
                first_move = self.current_player.make_first_move(@board) #e.g.[2,4] format
                if first_move !=nil
                    if self.board[first_move].color != current_player.color
                        puts "You can only move your own pieces!"
                        self.display.cursor.toggle_selected
                        raise SideError
                    end
                    break
                end
            end

            while true
                system("clear")
                self.display.render
                puts "#{self.current_player.color.capitalize}'s turn to move. Choose where to move your #{self.board[first_move].class}"
                next_move = self.current_player.make_next_move(@board, first_move) #e.g. [3,5] format
                if next_move != nil
                    self.board.move_piece(first_move, next_move)
                    swap_turn!
                    break
                end
            end
        end
        system("clear")
        self.display.render
        win_side = winner(self.board) 
        notify_players(win_side)

        rescue
            sleep 2
            retry
        end
    end

    def winner(board_instance) #returns color that wins
        if board_instance.checkmate?("white")
            return "black"
        end
        "white"
    end

    private

    def notify_players(winning_color)
        puts "Checkmate! " + winning_color.capitalize + " wins!"
    end

    def swap_turn!
        if self.current_player == @player1
            self.current_player = @player2
        else
            self.current_player = @player1
        end
        nil
    end

end

if __FILE__ == $PROGRAM_NAME
    game1 = Game.new(true, false)
    game1.play
end