class Call < ApplicationRecord
  serialize :call_events, JSON
end
