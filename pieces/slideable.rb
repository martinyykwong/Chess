module Slideable

    HORIZONTAL_DIRS = [
        [-1,0],
        [+1,0],
        [0,-1],
        [0,+1]
    ]
 
    DIAGONAL_DIRS = [
        [-1,-1],
        [-1,+1],
        [+1,-1],
        [+1,+1]
    ]
 
 
    def moves #returns an array of moves a piece instance can move to, with units blockages considered
        array_of_directional_unit_vectors = move_dirs #array of directional unit vectors that a piece can move to
        piece_current_position = self.pos #[2,3] format

        moves_hash = Hash.new { |h, k| h[k] = [] }

        array_of_directional_unit_vectors.each do |unit_vector|
            moveable_pos = piece_current_position.clone

            while moveable_pos[0].between?(0,7) && moveable_pos[1].between?(0,7)
                moveable_pos[0] += unit_vector[0]
                moveable_pos[1] += unit_vector[1]
                if moveable_pos[0].between?(0,7) && moveable_pos[1].between?(0,7)
                    moves_hash[unit_vector] << moveable_pos.clone
                end 
            end
        end
        moves_hash #returns a hash of positions a piece instance can move to, without considering units blockages. Key is unit direction; value is array of possible movements
        grow_unblocked_moves_in_dir(moves_hash) #returns an array of possible unblocked moves from a given position 
    end

    def horizontal_dirs
        HORIZONTAL_DIRS
    end

    def diagonal_dirs
        DIAGONAL_DIRS
    end

    private

    def grow_unblocked_moves_in_dir(hash_of_possible_moves) #returns an array of positions a piece instance can move to, considering units blockages
        piece_color = self.color
        array_of_unblocked_moves = []

        hash_of_possible_moves.each_value do |directional_path_array|
            directional_path_array.each do |position|
                if piece_color == self.board[position].color
                    break
                else
                    array_of_unblocked_moves << position
                    if !self.board[position].is_a?(NullPiece)
                        break
                    end
                end
            end
        end
        array_of_unblocked_moves
    end

end