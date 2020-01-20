class CatRentalRequest < ApplicationRecord
    def overlapping_requests
        currentRequests = CatRentalRequest.where(cat_id: self.cat_id, start_date: self.start_date..self.end_date, end_date: self.start_date..self.end_date)
        return currentRequests
    end
    
    def overlapping_approved_requests
        currentRequests = CatRentalRequest.where(status: "Approved", cat_id: self.cat_id, start_date: self.start_date..self.end_date, end_date: self.start_date..self.end_date)
        return currentRequests
    end

    def does_not_overlap_approved_request
        if self.overlapping_approved_requests.length > 0
          errors.add(:start_date, "can't overlap an approved rental request")
        end
    end
    
    validates :cat_id, presence: true
    validates :start_date, presence: true
    validates :end_date, presence: true
    validate :does_not_overlap_approved_request

    belongs_to :cat,
        primary_key: :id,
        foreign_key: :cat_id,
        class_name: :Cat

    

    

end
