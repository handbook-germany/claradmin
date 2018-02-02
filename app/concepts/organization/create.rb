# frozen_string_literal: true

class Organization::Create < Trailblazer::Operation
  include Assignable::CommonSideEffects::CreateNewAssignment

  step Model(::Organization, :new)
  step Policy::Pundit(PermissivePolicy, :create?)

  step Contract::Build(constant: Organization::Contracts::Create)
  step Contract::Validate()
  step Wrap(::Lib::Transaction) {
    step ::Lib::Macros::Nested::Create :website, Website::Create
    step ::Lib::Macros::Nested::Create :divisions, Division::Create
    step ::Lib::Macros::Nested::Create :contact_people, ContactPerson::Create
    step ::Lib::Macros::Nested::Create :locations, Location::Create
    step ::Lib::Macros::Nested::Find :topics, ::Topic
  }
  step :set_creating_user
  step Contract::Persist()
  step :generate_slug
  step :create_initial_assignment!
  step :create_generic_division

  def set_creating_user(_, current_user:, model:, **)
    model.created_by = current_user.id
  end

  def generate_slug(_, model:, **)
    model.update_column :slug, model.send(:set_slug)
  end

  def create_generic_division(_, current_user:, model:, **)
    if model.divisions.empty?
      location_city = model.locations.where(hq: true).first&.city
      params = {
        addition: 'Generic', comment: 'Generic default division',
        organization: model, websites: [{ id: model.website.id }],
        area: location_city ? nil : ::Area.find_by(name: 'Deutschland'),
        city: location_city
      }
      ::Division::Create.(params, 'current_user' => current_user).success?
    else
      true
    end
  end
end
