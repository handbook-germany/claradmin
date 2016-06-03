# frozen_string_literal: true
require_relative '../test_helper'

class SubscribedEmailsMailingsSpawnerWorkerTest < ActiveSupport::TestCase
  # extend ActiveSupport::TestCase to get fixtures
  let(:worker) { SubscribedEmailsMailingsSpawnerWorker.new }

  it 'sends mailing to subscribed emails that have approved offers' do
    email = FactoryGirl.create :email, :subscribed, :with_approved_offer
    SubscribedEmailMailingWorker.expects(:perform_async).with(email.id)
    worker.perform
  end

  it 'wont send mailing to subscribed emails without approved offers' do
    FactoryGirl.create :email, :subscribed, :with_unapproved_offer
    SubscribedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end

  it 'wont send mailing to unsubscribed emails that have approved offers' do
    FactoryGirl.create :email, :unsubscribed, :with_approved_offer
    SubscribedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end

  it 'wont send mailing to uninformed emails that have approved offers' do
    FactoryGirl.create :email, :uninformed, :with_approved_offer
    SubscribedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end

  it 'wont send mailing to informed emails that have approved offers' do
    FactoryGirl.create :email, :informed, :with_approved_offer
    SubscribedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end

  it 'wont send mailing to subscribed emails with approved offers but no'\
     ' mailings_enabled organization' do
    email = FactoryGirl.create :email, :subscribed, :with_approved_offer
    email.organizations.update_all mailings_enabled: false
    SubscribedEmailMailingWorker.expects(:perform_async).never
    worker.perform
  end
end