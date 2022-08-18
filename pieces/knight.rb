require_relative 'piece'
require_relative 'stepable'

class Knight < Piece

    include Stepable

    def initialize(color, board_instance, board_position)
        super
    end

    def symbol
        " ♘ "
    end

    protected

    def move_diffs
        [
        [-2,-1],
        [-1,-2],
        [+2,-1],
        [+1,-2],
        [+2,+1],
        [+1,+2],
        [-2,+1],
        [-1,+2]
        ]
    end

end