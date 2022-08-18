class Piece

    attr_reader :color
    attr_accessor :pos, :board
    
    def initialize(color, board_instance, board_position)
        @color = color
        @board = board_instance
        @pos = board_position #in array format [1,2]
    end

    def opposite_color
        if self.color == "black"
            "white"
        elsif self.color == "white"
            "black"
        else
            nil
        end
    end

    def valid_moves #returns an array of positions a piece instance can move to without putting own king in check
        playable_moves = moves.reject {|move| move_into_check?(move)}
    end

    def move_into_check?(end_pos)
        theoretical_board = self.board.dup
        theoretical_board.move_piece!(self.pos,end_pos)
        theoretical_board.in_check?(self.color)
    end

    def inspect
        {"Piece subclass" => self.class, "Piece ID" => self.object_id, "Board ID" => self.board.object_id, "Color" => self.color,"Position" => self.pos,"position ID" => self.pos.object_id}
    end

    def ===(class_type)
        self.is_a?(class_type)
    end

end