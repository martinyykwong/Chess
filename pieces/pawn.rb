require_relative 'piece'

class Pawn < Piece
    def initialize(color, board_instance, board_position)
        super
    end

    def symbol
        " ♙ "
    end

    def moves #returns array of allowed moves, with blockages considered
        array_of_allowed_moevs = forward_steps + side_attacks
    end

    private

    def at_start_row? #returns boolean
        (self.color == "black" && self.pos[0] == 1) || (self.color == "white" && self.pos[0] == 6)
    end

    def forward_dir
        if self.color == "black"
            return +1
        end
        -1
    end

    def forward_steps #returns array of possible forward steps locations e.g. [[2,3],[3,3]]
        forward_row = self.pos[0] + forward_dir
        available_space_ahead = self.board[[forward_row, self.pos[1]]].is_a?(NullPiece) #boolean of whether space is available 1 row ahead

        possible_steps = []
        if !available_space_ahead
            return possible_steps
        elsif at_start_row?
            double_forward_row = forward_row + forward_dir
            available_double_ahead = self.board[[double_forward_row, self.pos[1]]].is_a?(NullPiece)
            if available_double_ahead
                possible_steps << [double_forward_row, self.pos[1]]
            end
        end
        possible_steps << [forward_row, self.pos[1]]
        possible_steps
    end

    def side_attacks #returns array of possible attack locations e.g. [[2,2],[2,4]]
        attacking_piece_color = self.color
        forward_row = self.pos[0] + forward_dir
        left_col = self.pos[1] - 1
        right_col = self.pos[1] + 1
        
        possible_attacks = []
        if forward_row.between?(0,7) && left_col.between?(0,7) && self.board[[forward_row, left_col]].color == opposite_color
            possible_attacks << [forward_row, left_col]
        end

        if forward_row.between?(0,7) && right_col.between?(0,7) && self.board[[forward_row, right_col]].color == opposite_color
            possible_attacks << [forward_row, right_col]
        end
        possible_attacks
    end

    def opposite_color #returns the opposite color of current pawn instance
        if self.color == "black"
            return "white"
        end
        "black"
    end

end