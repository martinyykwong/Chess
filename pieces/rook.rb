require_relative 'piece'
require_relative 'slideable'

class Rook < Piece

    include Slideable

    def initialize(color, board_instance, board_position)
        super
    end

    def symbol
        " ♖ "
    end

    private

    def move_dirs
        horizontal_dirs
    end

end