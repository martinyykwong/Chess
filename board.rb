require_relative 'pieces/piece'
require_relative 'pieces/rook'
require_relative 'pieces/knight'
require_relative 'pieces/bishop'
require_relative 'pieces/queen'
require_relative 'pieces/king'
require_relative 'pieces/pawn'
require_relative 'pieces/nullpiece'

class Board

    attr_accessor :rows

    def initialize (need_fill_board = true)
        @rows = Array.new(8) {Array.new(8)}
        if need_fill_board
            fill_board
        end
    end

    def [](position_array)
        row = position_array[0]
        col = position_array[1]
        self.rows[row][col]
    end

    def []=(position_array, value)
        row = position_array[0]
        col = position_array[1]
        self.rows[row][col] = value
    end

    def move_piece(start_pos, end_pos)
        if self[start_pos].is_a?(NullPiece)
            puts "There is nothing to move."
            raise MovementError
        elsif self[start_pos].color == self[end_pos].color
            puts "You cannot eat your own piece!"
            raise MovementError
        elsif !(self[start_pos].valid_moves.include?(end_pos))
            puts "Invalid movement for this #{self[start_pos].class} piece."
            raise CheckError
        elsif self[end_pos] == nil || self[start_pos] == nil #might be unnecessary since we will be using cursor input
            puts "Cannot move outside of board"
            raise BoundaryError
        end
        
        self[end_pos] = self[start_pos]
        self[end_pos].pos = end_pos
        self[start_pos] = NullPiece.instance

        if self[end_pos].is_a?(Pawn)
            check_pawn_promotion(self[end_pos],end_pos)
        end
    end

    def move_piece!(start_pos, end_pos)
        if self[start_pos].is_a?(NullPiece)
            puts "There is no piece at #{start_pos} to move."
            raise MovementError
        elsif self[start_pos].color == self[end_pos].color
            puts "You cannot eat your own piece!"
            raise MovementError
        end

        self[end_pos] = self[start_pos]
        self[end_pos].pos = end_pos
        self[start_pos] = NullPiece.instance

        if self[end_pos].is_a?(Pawn)
            check_pawn_promotion(self[end_pos],end_pos)
        end
    end

    def check_pawn_promotion(pawn_instance, position)
        if (pawn_instance.color == "black") && (pawn_instance.pos[0] == 7) || (pawn_instance.color == "white") && (pawn_instance.pos[0] == 0)
            self.add_piece((Queen.new(pawn_instance.color, self, position)), position)
        end
    end

    def add_piece(piece_instance, pos)
        self[pos] = piece_instance
    end

    def valid_pos?(position_array)
        position_array[0].between?(0,7) && position_array[1].between?(0,7)
    end

    def fill_board
        self.rows.each_with_index do |row, m|
            if m == 0
                rows[0] = [
                    Rook.new("black", self, [0,0]),
                    Knight.new("black", self, [0,1]),
                    Bishop.new("black", self, [0,2]),
                    Queen.new("black", self, [0,3]),
                    King.new("black", self, [0,4]),
                    Bishop.new("black", self, [0,5]),
                    Knight.new("black", self, [0,6]),
                    Rook.new("black", self, [0,7])
                ]
            elsif m == 1
                rows[1] = [
                    Pawn.new("black", self, [1,0]),
                    Pawn.new("black", self, [1,1]),
                    Pawn.new("black", self, [1,2]),
                    Pawn.new("black", self, [1,3]),
                    Pawn.new("black", self, [1,4]),
                    Pawn.new("black", self, [1,5]),
                    Pawn.new("black", self, [1,6]),
                    Pawn.new("black", self, [1,7]),
                ]
            elsif m == 6
                rows[6] = [
                    Pawn.new("white", self, [6,0]),
                    Pawn.new("white", self, [6,1]),
                    Pawn.new("white", self, [6,2]),
                    Pawn.new("white", self, [6,3]),
                    Pawn.new("white", self, [6,4]),
                    Pawn.new("white", self, [6,5]),
                    Pawn.new("white", self, [6,6]),
                    Pawn.new("white", self, [6,7])
                ]
            elsif m == 7
                rows[7] = [
                    Rook.new("white", self, [7,0]),
                    Knight.new("white", self, [7,1]),
                    Bishop.new("white", self, [7,2]),
                    Queen.new("white", self, [7,3]),
                    King.new("white", self, [7,4]),
                    Bishop.new("white", self, [7,5]),
                    Knight.new("white", self, [7,6]),
                    Rook.new("white", self, [7,7])
                ]
            else
                rows[m] = [
                    NullPiece.instance,
                    NullPiece.instance,
                    NullPiece.instance,
                    NullPiece.instance,
                    NullPiece.instance,
                    NullPiece.instance,
                    NullPiece.instance,
                    NullPiece.instance
                ]
            end
        end
    end

    def in_check?(color)
        king_pos = self.find_king(color) # e.g. [0,4]
        opponent_color = self[king_pos].opposite_color
        self.rows.each do |row|
            row.each do |piece_instance|
                if (piece_instance.color == opponent_color) && (piece_instance.moves.include?(king_pos))
                    return true
                end
            end
        end
        false
    end

    def checkmate?(color)
        self.rows.each do |row|
            row.each do |piece|
                if (piece.color == color) && (piece.valid_moves.length > 0)
                    return false
                end
            end
        end
        true
    end

    def find_king(color) #returns an array e.g. [0,4]
        self.rows.each_with_index do |row,m|
            row.each_with_index do |col, n|
                if col.is_a?(King) && (color == col.color)
                    return col.pos
                end
            end
        end
        nil
    end

    def dup
        alt_board = Board.new(false)
        self.rows.each_with_index do |row,m|
            row.each_with_index do |piece,n|
                case piece
                when Rook
                    alt_board.add_piece(Rook.new("#{piece.color}",alt_board,[m,n]),[m,n])
                when Knight
                    alt_board.add_piece(Knight.new("#{piece.color}",alt_board,[m,n]),[m,n])
                when Bishop
                    alt_board.add_piece(Bishop.new("#{piece.color}",alt_board,[m,n]),[m,n])
                when Queen
                    alt_board.add_piece(Queen.new("#{piece.color}",alt_board,[m,n]),[m,n])
                when King
                    alt_board.add_piece(King.new("#{piece.color}",alt_board,[m,n]),[m,n])
                when Pawn
                    alt_board.add_piece(Pawn.new("#{piece.color}",alt_board,[m,n]),[m,n])
                when NullPiece
                    alt_board.add_piece(NullPiece.instance,[m,n])
                end
            end
        end
        alt_board   
    end

    def inspect
        self.rows.map {|row| row.map {|instance| instance.class}}
    end

    def look(position_array)
        p [self.rows[position_array[0]][position_array[1]].class,
        self.rows[position_array[0]][position_array[1]].color,
        self.rows[position_array[0]][position_array[1]].pos]
    end

end