require_relative 'piece'
require_relative 'slideable'

class Queen < Piece

    include Slideable

    def initialize(color, board_instance, board_position)
        super
    end

    def symbol
        " ♕ "
    end

    private

    def move_dirs
        horizontal_dirs + diagonal_dirs
    end

end