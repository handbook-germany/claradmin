# frozen_string_literal: true
# Monkeypatch clarat_base Offer
require ClaratBase::Engine.root.join('app', 'models', 'offer')

class Offer < ActiveRecord::Base
  has_paper_trail

  include PgSearch
  pg_search_scope :search_by_tester, against: [:name, :description,
                                               :aasm_state],
                                     using: { tsearch: { prefix: true } }

  pg_search_scope :search_everything,
                  # TODO: we might have to limit this for performance
                  # against: attribute_names.map(&:to_sym),
                  against: [
                    :name, :description, :aasm_state, :encounter,
                    :old_next_steps, :legal_information, :code_word
                  ],
                  associated_against: {
                    section_filters: :name,
                    organizations: :name,
                    location: :display_name,
                    categories: :name_de,
                    solution_category: :name,
                    target_audience_filters: :name,
                    trait_filters: :name,
                    logic_version: :name
                  },
                  using: { tsearch: { prefix: true } }

  # TODO? This works in console but raises ArgumentError otherwise...
  # pg_search_scope :search_dynamic, (lambda do |name_part, query|
  #   raise ArgumentError unless respond_to?(name_part)
  #   {
  #     against: name_part,
  #     query: query,
  #     using: { tsearch: { prefix: true } }
  #   }
  # end)

  # Associations
  has_many :offer_mailings, inverse_of: :offer
  has_many :informed_emails, source: :email, through: :offer_mailings,
                             inverse_of: :known_offers

  # Scopes
  scope :approved, -> { where(aasm_state: 'approved') }
  scope :seasonal, -> { where('starts_at IS NOT null') }
  scope :by_mailings_enabled_organization, lambda {
    joins(:organizations).where('organizations.mailings = ?', 'enabled')
  }

  # Admin specific methods

  # Customize duplication.
  # Lots of configs here, so we are OK with a longer method:
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def partial_dup
    self.dup.tap do |offer|
      offer.created_by = nil
      offer.location = self.location
      offer.organizations = self.organizations
      offer.openings = self.openings
      offer.categories = self.categories
      offer.section_filters = self.section_filters
      offer.language_filters = self.language_filters
      offer.target_audience_filters = self.target_audience_filters
      offer.trait_filters = self.trait_filters
      offer.websites = self.websites
      offer.contact_people = self.contact_people
      offer.keywords = self.keywords
      offer.next_steps = self.next_steps
      offer.area = self.area
      offer.aasm_state = 'initialized'
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def editable?
    aasm_state == 'initialized' || aasm_state == 'approval_process' ||
      aasm_state == 'checkup_process'
  end
end
