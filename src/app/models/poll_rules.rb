class PollRule < ActiveRecord::Base
include ActiveUUID::UUID
  belongs_to :poll
  belongs_to :choice
end