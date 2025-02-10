class PostDeletionJob < ApplicationJob
    include Sidekiq::Job
    def perform
      #delet post if create time more than 24 hours
      # Post.where("created_at < ?", 10.hours.ago).destroy_all
      #testing
      Post.where("created_at < ?", 10.minutes.ago).destroy_all
    end
  end