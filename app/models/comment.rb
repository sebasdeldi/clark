# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  message_id :integer
#  user_id    :integer
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Comment < ActiveRecord::Base
  belongs_to :message
  belongs_to :user

  after_commit { CommentRelayJob.perform_later(self) }
end
