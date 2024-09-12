class Todo < ApplicationRecord

    validates_presence_of :name
    validate :duedate_is_in_the_future


    enum status: {
        incomplete: 0,
        complete: 1
    }

    private

    def duedate_is_in_the_future
        if duedate.present? && duedate < Date.today
        errors.add(:duedate, "must be in the future")
        end
    end
end
