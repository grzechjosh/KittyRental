include ActionView::Helpers::DateHelper

class Cat < ApplicationRecord
    valid_colors = %w( Black White Grey Orange Brown Hairless )
    validates :color, inclusion: { in: valid_colors }
    validates :sex, inclusion: { in: %w(M F) }

    def age
        date_then = self.birth_date
        return distance_of_time_in_words_to_now(date_then)
    end
    
    has_many :cat_rental_requests,
        primary_key: :id,
        foreign_key: :cat_id,
        class_name: :CatRentalRequest,
        dependent: :destroy
end


