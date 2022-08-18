require_relative 'player'
require_relative '../display'

class HumanPlayer < Player

    def initialize(color, display_instance)
        super
    end

    def make_first_move(board_instance)
        desired_move = self.display.cursor.get_input
    end

    def make_next_move(board_instance, initial_move_pos)
        desired_move = self.display.cursor.get_input
    end


end