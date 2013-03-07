# -*- encoding : utf-8 -*-
ActsAsTaggableOn.remove_unused_tags = true
ActsAsTaggableOn.force_lowercase = true

module ActsAsTaggableOn
  class Tag < ::ActiveRecord::Base
    has_many :subscriptions, :as => :subscribable
    has_many :subscribers, :through => :subscriptions, :source => :user
  end
end
