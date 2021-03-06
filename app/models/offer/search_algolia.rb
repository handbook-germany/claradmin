# frozen_string_literal: true

require ClaratBase::Engine.root.join('app', 'models', 'offer')

module Offer::SearchAlgolia
  extend ActiveSupport::Concern

  included do
    include AlgoliaSearch

    algoliasearch per_environment: true, disable_indexing: Rails.env.test? do
      I18n.available_locales.each do |locale|
        index = %w[
          name code_word tags tag_keywords description definitions
          organization_names solution_category trait_filter language_filter
        ]
        attributes = %i[organization_count location_address location_name
                        slug encounter organization_names location_visible
                        code_word]
        facets = %i[_age_filters _language_filters _target_audience_filters
                    _exclusive_gender_filters section_identifier
                    _residency_status_filters]

        add_index Offer.personal_index_name(locale),
                  disable_indexing: Rails.env.test?,
                  if: :personal_indexable? do
          attributesToIndex index
          ranking %w[typo geo words proximity attribute exact custom]
          attribute(:name) { send("name_#{locale}") }
          attribute(:description) { send("description_#{locale}") }
          attribute(:next_steps)  { _next_steps locale }
          attribute(:lang) { lang(locale) }
          attribute(:definitions) { definitions_string(locale) }
          attribute(:tags) { tag_names(locale) }
          # NOTE _tags is algolia-intern (not redundant with tags)
          attribute(:_tags) { tag_names(locale) }
          attribute(:stamps_string) { stamps_string(locale) }
          attribute(:singular_stamp) { singular_stamp(locale) }
          attribute(:tag_keywords) { tag_keywords(locale) }
          attribute(:solution_category) { solution_category&.name }
          attribute(:trait_filter) { trait_filters.map(&:name) }
          attribute(:language_filter) { language_filters.map(&:name) }
          add_attribute(*attributes)
          add_attribute(*facets)
          add_attribute :_geoloc
          attributesForFaceting facets + [:_tags]
          optionalWords STOPWORDS
        end

        add_index Offer.remote_index_name(locale),
                  disable_indexing: Rails.env.test?,
                  if: :remote_indexable? do
          attributesToIndex index
          attribute(:name) { send("name_#{locale}") }
          attribute(:description) { send("description_#{locale}") }
          attribute(:next_steps)  { _next_steps locale }
          attribute(:lang) { lang(locale) }
          attribute(:definitions) { definitions_string(locale) }
          attribute(:_tags) { tag_names(locale) }
          attribute(:stamps_string) { stamps_string(locale) }
          attribute(:singular_stamp) { singular_stamp(locale) }
          attribute(:tag_keywords) { tag_keywords(locale) }
          attribute(:solution_category) { solution_category&.name }
          attribute(:trait_filter) { trait_filters.map(&:name) }
          attribute(:language_filter) { language_filters.map(&:name) }
          add_attribute(*attributes)
          add_attribute :area_minlat, :area_maxlat, :area_minlong,
                        :area_maxlong
          add_attribute(*facets)
          attributesForFaceting facets + %i[_tags encounter]
          optionalWords STOPWORDS

          # no geo necessary
          ranking %w[typo words proximity attribute exact custom]
        end
      end
    end
  end
end
