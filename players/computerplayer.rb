require_relative 'player'
require_relative '../board'

class ComputerPlayer < Player

    def initialize(color, display_instance)
        super
    end

    def make_first_move(board_instance) #returns an array e.g. [2,3]
        valid_pieces_array = []
        board_instance.rows.each do |row|
            row.each do |piece_instance|
                if (piece_instance.color == self.color) && (piece_instance.valid_moves.length > 0)
                    valid_pieces_array << piece_instance
                end
            end
        end
        valid_pieces_array.sample.pos
    end

    def make_next_move(board_instance, initial_move_pos) #returns a valid position that the chosen piece can move to
        position_of_starting_piece = initial_move_pos
        board_instance[initial_move_pos].valid_moves.sample
    end

end