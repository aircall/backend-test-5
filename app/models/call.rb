# == Schema Information
#
# Table name: calls
#
#  id           :bigint(8)        not null, primary key
#  country      :string
#  end_at       :datetime
#  phone_number :string
#  provider_sid :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Call < ApplicationRecord
end