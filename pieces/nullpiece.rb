require_relative 'piece'
require 'singleton'

class NullPiece < Piece
    
    include Singleton

    attr_reader :color
    
    def initialize
        @color = nil
    end

    def symbol
        "   "
    end

    def moves
        array_of_moves = []
        (0..7).each do |row|
            (0..7).each do |col|
                array_of_moves << [row, col]
            end
        end
        array_of_moves
    end

end