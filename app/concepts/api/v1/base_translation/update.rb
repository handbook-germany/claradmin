# frozen_string_literal: true
#### DEPRECATED ####
module API::V1
  module BaseTranslation
    # class Update < Trailblazer::Operation # API::V1::Assignable::Update
    #   def initialize(translation, object, fields)
    #     @object = object
    #     @fields = fields
    #     @model = translation
    #   end
    #
    #   def update_and_assign
    #     raise 'Stop calling me!'
    #     # update fields and save model
    #     @model.assign_attributes(@fields)
    #     @model.save!
    #
    #     # call process of Assignable::Update for Assignment logic
    #     process(nil)
    #   end
    #
    #   protected
    #
    #   # override default Assignable::Update logic
    #   def assignment_creator_id
    #     ::User.system_user.id
    #   end
    #
    #   def assignment_receiver_id
    #     assign_to_translator_team? ? nil : ::User.system_user.id
    #   end
    #
    #   def assignment_receiver_team_id
    #     assign_to_translator_team? ?
    #       AssignmentDefaults.translator_teams[@model.locale.to_s] : nil
    #   end
    #
    #   # only re-assign refugees translations, that are outdated or from GT and
    #   # if they are not already assigned to the translator team
    #   def reassign?
    #     @object.section_filters.pluck(:identifier).include?('refugees') &&
    #       (@model.possibly_outdated || @model.source == 'GoogleTranslate') &&
    #       already_assigned_to_translator_team? == false
    #   end
    #
    #   def message_for_new_assignment
    #     if assign_to_translator_team?
    #       associated_object_user =
    #         ::User.find(
    #           @object.approved_by ? @object.approved_by : @object.created_by
    #         )
    #       (@model.possibly_outdated ? 'possibly_outdated' : 'GoogleTranslate') +
    #         " (#{associated_object_user.name})"
    #     else
    #       'Managed by system'
    #     end
    #   end
    #
    #   private
    #
    #   def assign_to_translator_team?
    #     @model.manually_editable?
    #   end
    #
    #   def already_assigned_to_translator_team?
    #     assignable.current_assignment.receiver_team_id ==
    #       AssignmentDefaults.translator_teams[@model.locale.to_s]
    #   end
    #
    #   # returns decorated model
    #   def assignable
    #     @assignable ||= ::Assignable::Twin.new(@model)
    #   end
    # end
  end
end
