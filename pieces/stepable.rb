module Stepable

    def moves #returns an array of positions a piece instance can move to, with units blockage considered
        array_of_allowed_moves_vectors = self.move_diffs #array of directional vectors that a piece can move to
        piece_current_position = self.pos #[2,3] format

        array_of_unblocked_moves = []
        array_of_allowed_moves_vectors.each do |move_direction_vector|
            destination_position = [piece_current_position[0] + move_direction_vector[0], piece_current_position[1] + move_direction_vector[1]]
            if destination_position[0].between?(0,7) && destination_position[1].between?(0,7) && self.board[destination_position].color != self.color 
                array_of_unblocked_moves << destination_position
            end
        end
        array_of_unblocked_moves
    end
    
end