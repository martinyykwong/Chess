require 'colorize'
require_relative 'board'
require_relative 'cursor'

class Display

    attr_reader :board, :cursor

    def initialize(board)
        @board = board #board instance
        @cursor = Cursor.new([0,0],board) #cursor instance
    end

    def render
        cursor_current_position = self.cursor.cursor_pos #[1,5] format
        cursor_selected = self.cursor.selected #true/false

        self.board.rows.each_with_index do |row, m|
            display_row = row.map.with_index do |piece, n|
                if [m,n] == cursor_current_position
                    if cursor_selected
                        piece.symbol.blue.on_green
                    else
                        if [m,n].all? {|num| num.even?} || [m,n].all? {|num| num.odd?}
                            piece.symbol.blue.on_blue
                        else
                            piece.symbol.blue.on_blue #possible to have different color
                        end
                    end
                else
                    if piece.color == "black"
                        if [m,n].all? {|num| num.even?} || [m,n].all? {|num| num.odd?}
                            piece.symbol.red.on_black
                        else
                            piece.symbol.red
                        end
                    else
                        if [m,n].all? {|num| num.even?} || [m,n].all? {|num| num.odd?}
                            piece.symbol.white.on_black
                        else
                            piece.symbol.white
                        end
                    end
                end
            end
            puts display_row.join("")
        end

    end

end